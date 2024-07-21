defmodule Cube do
  def main() do
    vertices = [
      [-10, 10, 10],
      [-10, -10, 10],
      [10, 10, 10],
      [10, -10, 10],
      [-10, 10, -10],
      [-10, -10, -10],
      [10, 10, -10],
      [10, -10, -10]
    ]

    loop(vertices)
  end

  def loop(vertices) do
    {a, b, c} = {0.01, 0.02, 0.01}
    rot = Enum.map(vertices, fn vertex ->
      [x, y, z] = vertex
      p = []
      p = [calculateZ(x, y, z, a, b) | p]
      p = [calculateY(x, y, z, a, b, c) | p]
      p = [calculateX(x, y, z, a, b, c) | p]
      p
    end)

    draw(rot)
    loop(rot)
  end

  def draw(vertices) do
    Enum.map(vertices, fn vertex ->
      [x, y, _z] = Enum.map(vertex, fn coordinate -> Float.floor(coordinate) end)
      yScale = 0.75
      IO.write(IO.ANSI.cursor(round(elem(:io.rows(), 1)/2 - y * yScale), round(x + elem(:io.columns(), 1)/2)))
      IO.write("$")
    end)
    IO.write("\e[?25l")
    :timer.sleep(20)
    IO.write(IO.ANSI.clear())
  end

  def calculateX(x, y, z, a, b, c) do
    [sinA, sinB, sinC] = Enum.map([a, b, c], & :math.sin/1)
    [cosA, cosB, cosC] = Enum.map([a, b, c], & :math.cos/1)
    y * sinA * sinB * cosC - z * cosA * sinB * cosC + y * cosA * sinC + z * sinA * sinC + x * cosB * cosC
  end

  def calculateY(x, y, z, a, b, c) do
    [sinA, sinB, sinC] = Enum.map([a, b, c], & :math.sin/1)
    [cosA, cosB, cosC] = Enum.map([a, b, c], & :math.cos/1)
    y * cosA * cosC + z * sinA * cosC - y * sinA * sinB * sinC + z * cosA * sinB * sinC - x * cosB * sinC
  end

  def calculateZ(x, y, z, a, b) do
    [sinA, sinB] = Enum.map([a, b], & :math.sin/1)
    [cosA, cosB] = Enum.map([a, b], & :math.cos/1)
    z * cosA * cosB - y * sinA * cosB + x * sinB
  end

end

Cube.main()
