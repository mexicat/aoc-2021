defmodule AdventOfCode.Day15 do
  def part1(input) do
    grid = parse_input(input)
    graph = make_graph(grid)
    min = {0, 0}
    max = grid |> Map.keys() |> Enum.max()

    graph
    |> Graph.dijkstra(min, max)
    |> Enum.drop(1)
    |> Enum.map(&Map.get(grid, &1))
    |> Enum.sum()
  end

  def part2(input) do
    grid = input |> parse_input() |> expand_grid()
    graph = make_graph(grid)
    min = {0, 0}
    max = grid |> Map.keys() |> Enum.max()

    graph
    |> Graph.dijkstra(min, max)
    |> Enum.drop(1)
    |> Enum.map(&Map.get(grid, &1))
    |> Enum.sum()
  end

  def make_graph(grid) do
    Enum.reduce(grid, Graph.new(), fn {{x, y}, _w}, graph ->
      nbs =
        [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
        |> Enum.map(fn point -> {{x, y}, point, [weight: Map.get(grid, point)]} end)
        |> Enum.filter(fn {_, _, [weight: w]} -> w end)

      Graph.add_edges(graph, nbs)
    end)
  end

  def expand_grid(grid) do
    max = grid |> Map.keys() |> Enum.max()

    grid
    |> Enum.flat_map(fn point ->
      for x1 <- 0..4, y1 <- 0..4, {x1, y1} != {0, 0} do
        replicate_point(point, {x1, y1}, max)
      end
    end)
    |> Enum.into(grid)
  end

  def replicate_point({{x, y}, w}, {x1, y1}, {max_y, max_x}) do
    w = w + x1 + y1
    w = if w > 9, do: rem(w, 9), else: w
    x = x + (max_x + 1) * x1
    y = y + (max_y + 1) * y1

    {{x, y}, w}
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {col, y} <- Enum.with_index(lines),
        {row, x} <- Enum.with_index(String.codepoints(col)),
        into: %{} do
      {{x, y}, String.to_integer(row)}
    end
  end
end
