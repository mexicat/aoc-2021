defmodule AdventOfCode.Day05 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce(%{}, &fill_floor_filtered/2)
    |> Enum.count(fn {_k, v} -> v > 1 end)
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.reduce(%{}, &fill_floor/2)
    |> Enum.count(fn {_k, v} -> v > 1 end)
  end

  def fill_floor_filtered({{x1, y1}, {x2, y2}}, floor) when x1 != x2 and y1 != y2, do: floor
  def fill_floor_filtered(vent, floor), do: fill_floor(vent, floor)

  def fill_floor({{x, y1}, {x, y2}}, floor) do
    for y <- y1..y2,
        do: {{x, y}, Map.get(floor, {x, y}, 0) + 1},
        into: floor
  end

  def fill_floor({{x1, y}, {x2, y}}, floor) do
    for x <- x1..x2,
        do: {{x, y}, Map.get(floor, {x, y}, 0) + 1},
        into: floor
  end

  def fill_floor({{x1, y1}, {x2, y2}}, floor) do
    dist = abs(x2 - x1)
    x_dir = if x1 < x2, do: 1, else: -1
    y_dir = if y1 < y2, do: 1, else: -1

    for i <- 0..dist,
        do:
          {{x1 + i * x_dir, y1 + i * y_dir},
           Map.get(floor, {x1 + i * x_dir, y1 + i * y_dir}, 0) + 1},
        into: floor
  end

  def fill_floor(_, floor), do: floor

  def parse_input(input) do
    lines =
      input
      |> String.splitter("\n", trim: true)
      |> Stream.map(&String.split(&1, " -> "))

    for [from, to] <- lines,
        do: {parse_point(from), parse_point(to)}
  end

  def parse_point(point) do
    [x, y] = String.split(point, ",")
    {String.to_integer(x), String.to_integer(y)}
  end

  def visualize(grid) do
    IO.puts("\n")
    max_x = grid |> Enum.map(fn {{x, _y}, _} -> x end) |> Enum.max()
    max_y = grid |> Enum.map(fn {{_x, y}, _} -> y end) |> Enum.max()

    for y <- 0..max_y do
      for x <- 0..max_x do
        Map.get(grid, {x, y}, ".")
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()
  end
end
