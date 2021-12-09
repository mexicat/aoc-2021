defmodule AdventOfCode.Day09 do
  def part1(input) do
    heightmap = parse_input(input)

    low_points =
      heightmap
      |> get_low_points()
      |> Enum.map(fn {_k, v} -> v end)

    Enum.count(low_points) + Enum.sum(low_points)
  end

  def part2(input) do
    heightmap = parse_input(input)
    low_points = get_low_points(heightmap)

    [a, b, c] =
      Enum.map(low_points, fn {point, _} ->
        heightmap
        |> find_basin([point], MapSet.new())
        |> Enum.count()
      end)
      |> Enum.sort()
      |> Enum.take(-3)

    a * b * c
  end

  def find_basin(_, [], found), do: found

  def find_basin(heightmap, [curr = {x, y} | rest], found) do
    case {curr in found, Map.get(heightmap, curr, 9)} do
      {false, 9} ->
        find_basin(heightmap, rest, found)

      {false, _} ->
        find_basin(
          heightmap,
          rest ++ [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}],
          MapSet.put(found, curr)
        )

      {true, _} ->
        find_basin(heightmap, rest, found)
    end
  end

  def get_low_points(heightmap) do
    heightmap
    |> Enum.filter(fn {{x, y}, v} ->
      up = Map.get(heightmap, {x, y - 1}, 9)
      down = Map.get(heightmap, {x, y + 1}, 9)
      left = Map.get(heightmap, {x - 1, y}, 9)
      right = Map.get(heightmap, {x + 1, y}, 9)

      up > v && down > v && left > v && right > v
    end)
  end

  def parse_input(input) do
    input
    |> String.codepoints()
    |> Enum.reduce({%{}, 0, 0}, fn
      "\n", {acc, _x, y} ->
        {acc, 0, y + 1}

      n, {acc, x, y} ->
        {Map.put(acc, {x, y}, String.to_integer(n)), x + 1, y}
    end)
    |> elem(0)
  end
end
