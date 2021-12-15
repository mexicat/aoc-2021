defmodule AdventOfCode.Day13 do
  def part1(input) do
    {dots, folds} = parse_input(input)

    apply_fold(Enum.at(folds, 0), dots) |> visualize() |> Enum.count()
  end

  def part2(input) do
    {dots, folds} = parse_input(input)

    Enum.reduce(folds, dots, &apply_fold/2) |> visualize()
  end

  def apply_fold(pos, dots) do
    Enum.reduce(dots, MapSet.new(), fn dot, acc ->
      MapSet.put(acc, fold_point(pos, dot))
    end)
  end

  def fold_point({:y, n}, {x, y}) when y > n, do: {x, n - (y - n)}
  def fold_point({:x, n}, {x, y}) when x > n, do: {n - (x - n), y}
  def fold_point(_, dot), do: dot

  def parse_input(input) do
    [dots, folds] = String.split(input, "\n\n", trim: true)

    dots =
      dots
      |> String.split("\n")
      |> Enum.map(fn dot ->
        [x, y] = String.split(dot, ",")
        {String.to_integer(x), String.to_integer(y)}
      end)
      |> MapSet.new()

    folds =
      folds
      |> String.split("\n", trim: true)
      |> Enum.map(fn fold ->
        [pos, n] = fold |> String.trim_leading("fold along ") |> String.split("=")
        {String.to_atom(pos), String.to_integer(n)}
      end)

    {dots, folds}
  end

  def visualize(grid) do
    max_x = grid |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = grid |> Enum.map(fn {_x, y} -> y end) |> Enum.max()

    for y <- 0..max_y do
      for x <- 0..max_x do
        if MapSet.member?(grid, {x, y}), do: "█", else: " "
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()

    grid
  end
end
