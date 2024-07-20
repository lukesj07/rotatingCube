defmodule Cube do
  def main() do
    
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
