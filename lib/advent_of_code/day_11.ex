defmodule AdventOfCode.Day11 do
  @dirs [
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1}
  ]

  def part1(input) do
    grid = parse_input(input)

    {_, flashes} =
      Enum.reduce(1..100, {grid, 0}, fn _, {grid, flashes} -> step(grid, flashes) end)

    flashes
  end

  def part2(input) do
    grid = parse_input(input)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({grid, 0}, fn n, {grid, flashes} ->
      case Enum.count(Map.values(grid), &(&1 == 0)) do
        100 -> {:halt, n}
        _ -> {:cont, step(grid, flashes)}
      end
    end)
  end

  def step(grid, flashes \\ 0) do
    {grid, new_flashes} =
      grid
      |> increase_energy()
      |> flash()

    {reset_levels(grid), flashes + new_flashes}
  end

  def increase_energy(grid) do
    Map.new(grid, fn {k, v} -> {k, v + 1} end)
  end

  def flash(grid, flashed \\ MapSet.new()) do
    to_flash =
      grid
      |> Enum.filter(fn {_k, v} -> v > 9 end)
      |> Enum.map(fn {k, _v} -> k end)
      |> MapSet.new()

    if to_flash == flashed do
      {grid, MapSet.size(flashed)}
    else
      flash(update_flashed(grid, flashed), to_flash)
    end
  end

  def update_flashed(grid, flashed) do
    Map.new(grid, fn {{x, y}, v} ->
      nbs =
        Enum.count(@dirs, fn {nx, ny} ->
          new_point = {x + nx, y + ny}
          Map.get(grid, new_point, 0) > 9 and new_point not in flashed
        end)

      {{x, y}, v + nbs}
    end)
  end

  def reset_levels(grid) do
    Map.new(grid, fn {k, v} -> if v > 9, do: {k, 0}, else: {k, v} end)
  end

  def parse_input(input) do
    lines = String.split(input, "\n", trim: true)

    for {row, x} <- Enum.with_index(lines),
        {col, y} <- Enum.with_index(String.codepoints(row)),
        into: %{} do
      {{x, y}, String.to_integer(col)}
    end
  end
end
