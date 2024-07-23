defmodule Cube do
  def main() do
    vertices = for x <- [-10, 10], y <- [-10, 10], z <- [-10, 10], do: [x, y, z]
    {a, b, c} = {0.01, 0.06, 0.03}
    IO.write("\e[?25l")
    loop(vertices, calculateConnects(vertices, [], 0, 0), Enum.map([a, b, c], & :math.sin/1), Enum.map([a, b, c], & :math.cos/1))
  end
  
  def calculateConnects(vertices, indices, i1, _i2) when i1 == length(vertices), do: indices
  def calculateConnects(vertices, indices, i1, i2) when i2 == length(vertices), do: calculateConnects(vertices, indices, i1 + 1, 0)
  def calculateConnects(vertices, indices, i1, i2) when i2 < length(vertices) do
    case {twoSharedDims(Enum.at(vertices, i1), Enum.at(vertices, i2)), [i2, i1] in indices} do
      {2, false} -> calculateConnects(vertices, indices ++ [[i1, i2]], i1, i2 + 1)
      _ -> calculateConnects(vertices, indices, i1, i2 + 1)
    end
  end
  
  def twoSharedDims(v1, v2), do: Enum.sum(for i <- 0..(length(v1) - 1), do: (if Enum.at(v1, i) == Enum.at(v2, i), do: 1, else: 0))

  def loop(vertices, connect, sin, cos) do
    rot = vertices |> Enum.map(fn [x, y, z] ->
      [calculateX(x, y, z, sin, cos), calculateY(x, y, z, sin, cos), calculateZ(x, y, z, sin, cos)]
    end)
    draw(rot, connect)
    loop(rot, connect, sin, cos)
  end

  def draw(vertices, connect) do
    Enum.map(connect, fn pair -> 
      [[x1, y1, _z1], [x2, y2, _z2]] = Enum.map(pair, fn i -> Enum.at(vertices, i) end)
      yScale = 0.6
      [screenY1, screenY2] = Enum.map([y1, y2], fn y -> round(elem(:io.rows(), 1) / 2 - y * yScale) end)
      [screenX1, screenX2] = Enum.map([x1, x2], fn x -> round(x + elem(:io.columns(), 1) / 2) end)
      d = round(:math.sqrt(:math.pow((screenX2 - screenX1), 2) + :math.pow((screenY2 - screenY1), 2)))
      for s <- 0..d do
        t = if d == 0, do: 0, else: s / d
        [x, y] = Enum.map([{screenX1, screenX2}, {screenY1, screenY2}], fn p -> round(elem(p, 0) + t * (elem(p, 1) - elem(p, 0))) end)
        IO.ANSI.cursor(y, x) <> "█" |> IO.write()
      end
    end)
    :timer.sleep(25)
    IO.ANSI.clear() |> IO.write()
  end

  def calculateX(x, y, z, [sA, sB, sC | _], [cA, cB, cC | _]), do: y*sA*sB*cC - z*cA*sB*cC + y*cA*sC + z*sA*sC + x*cB*cC
  def calculateY(x, y, z, [sA, sB, sC | _], [cA, cB, cC | _]), do: y*cA*cC + z*sA*cC - y*sA*sB*sC + z*cA*sB*sC - x*cB*sC
  def calculateZ(x, y, z, [sA, sB, _sC | _], [cA, cB, _cC | _]), do: z*cA*cB - y*sA*cB + x*sB
end

Cube.main()
