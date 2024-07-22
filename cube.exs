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
    loop(vertices, calculateIndices(vertices, [], 0, 0))
  end

  def calculateIndices(vertices, indices, i1, _i2) when i1 == length(vertices) do
    indices
  end

  def calculateIndices(vertices, indices, i1, i2) when i2 == length(vertices) do
    calculateIndices(vertices, indices, i1+1, 0)
  end
  
  def calculateIndices(vertices, indices, i1, i2) do
    if shared(Enum.at(vertices, i1), Enum.at(vertices, i2)) == 2 do
      calculateIndices(vertices, indices ++ [[i1, i2]], i1, i2+1)
    else
      calculateIndices(vertices, indices, i1, i2+1)
    end
  end
  
  def shared(v1, v2) do
    Enum.sum(for i <- 0..(length(v1)-1), do: if Enum.at(v1, i) == Enum.at(v2, i), do: 1, else: 0)
  end

  def loop(vertices, connect) do
    {a, b, c} = {0.1, 0.06, 0.02}
    rot = Enum.map(vertices, fn vertex ->
      [x, y, z] = vertex
      p = []
      p = [calculateZ(x, y, z, a, b) | p]
      p = [calculateY(x, y, z, a, b, c) | p]
      p = [calculateX(x, y, z, a, b, c) | p]
      p
    end)

    draw(rot, connect)
    loop(rot, connect)
  end

  def draw(vertices, connect) do
    Enum.map(connect, fn pair -> 
      [v1, v2] = Enum.map(pair, fn i -> Enum.at(vertices, i) end)
      [x1, y1, _z1] = v1
      [x2, y2, _z2] = v2
      yScale = 0.75
      [screenY1, screenY2] = Enum.map([y1, y2], fn y -> round(elem(:io.rows(), 1)/2 - y * yScale) end)
      [screenX1, screenX2] = Enum.map([x1, x2], fn x -> round(x + elem(:io.columns(), 1)/2) end)
      if screenX1 != screenX2 do
        m = (screenY2 - screenY1) / (screenX2 - screenX1)
        b = screenY2 - m * screenX2
        for x <- ([screenX1, screenX2] |> Enum.min())..([screenX1, screenX2] |> Enum.max()) do
          py = round(m * x + b)
          IO.write(IO.ANSI.cursor(py, x))
          IO.write("$")
        end
      else 
        for y <- ([screenY1, screenY2] |> Enum.min())..([screenY1, screenY2] |> Enum.max()) do
          IO.write(IO.ANSI.cursor(y, screenX1))
          IO.write("$")
        end
      end
    end)
    IO.write("\e[?25l")
    :timer.sleep(40)
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
