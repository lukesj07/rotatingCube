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
    theta = 0.01
    rot = Enum.map(vertices, fn vertex ->
      [x, y, z] = vertex
      p = []
      p = [calculateZ(x, y, z, theta) | p]
      p = [calculateY(x, y, z, theta) | p]
      p = [calculateX(x, y, z, theta) | p]
      p
    end)

    draw(rot)
    loop(rot)
  end

  def draw(vertices) do
    Enum.map(vertices, fn vertex ->
      [x, y, _z] = Enum.map(vertex, fn coordinate -> Float.floor(coordinate) end)
      # IO.puts(:io.rows()/2 - y, x + :io.columns()/2)
      IO.write(IO.ANSI.cursor(round(elem(:io.rows(), 1)/2 - y), round(x + elem(:io.columns(), 1)/2)))
      IO.write("$")
    end)
    :timer.sleep(10)
    IO.write(IO.ANSI.clear())
  end

  def calculateX(x, y, z, theta) do
    sin = :math.sin(theta)
    cos = :math.cos(theta)
    x * cos * cos - y * cos * sin + z * sin
  end

  def calculateY(x, y, z, theta) do
    sin = :math.sin(theta)
    cos = :math.cos(theta)
    x * (sin * sin * cos + cos * sin) + y * (cos * cos - sin * sin * sin) - z * sin * cos
  end

  def calculateZ(x, y, z, theta) do
    sin = :math.sin(theta)
    cos = :math.cos(theta)
    x * (sin * sin - cos * cos * sin) + y * (sin * sin * cos + sin * cos) + z * cos * cos
  end
end

Cube.main()
