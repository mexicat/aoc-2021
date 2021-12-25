defmodule AdventOfCode.Day25 do
  def part1(input) do
    grid = parse_input(input)
    max_x = grid |> Enum.map(fn {{x, _y}, _} -> x end) |> Enum.max()
    max_y = grid |> Enum.map(fn {{_x, y}, _} -> y end) |> Enum.max()

    Enum.reduce_while(1..99_999_999, grid, fn n, acc ->
      new_grid = step(acc, max_x, max_y)

      case new_grid == acc do
        true -> {:halt, n}
        false -> {:cont, new_grid}
      end
    end)
  end

  def step(grid, max_x, max_y) do
    step_1 =
      Enum.reduce(grid, grid, fn
        {{x, y}, ">"}, acc ->
          check_x = if x == max_x, do: 0, else: x + 1

          case Map.get(grid, {check_x, y}) do
            "." -> acc |> Map.put({x, y}, ".") |> Map.put({check_x, y}, ">")
            _ -> acc
          end

        _, acc ->
          acc
      end)

    step_2 =
      Enum.reduce(step_1, step_1, fn
        {{x, y}, "v"}, acc ->
          check_y = if y == max_y, do: 0, else: y + 1

          case Map.get(step_1, {x, check_y}) do
            "." -> acc |> Map.put({x, y}, ".") |> Map.put({x, check_y}, "v")
            _ -> acc
          end

        _, acc ->
          acc
      end)

    step_2
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {col, y} <- Enum.with_index(lines),
        {row, x} <- Enum.with_index(String.codepoints(col)),
        into: %{} do
      {{x, y}, row}
    end
  end
end
