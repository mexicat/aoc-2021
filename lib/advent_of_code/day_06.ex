defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.frequencies()
    |> pass_days(80)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.frequencies()
    |> pass_days(256)
    |> Map.values()
    |> Enum.sum()
  end

  def pass_days(fish, 0), do: fish

  def pass_days(fish, days_left) do
    fish
    |> Enum.reduce(%{}, fn
      {0, qt}, acc ->
        acc |> Map.update(6, qt, &(&1 + qt)) |> Map.put(8, qt)

      {n, qt}, acc ->
        acc |> Map.update(n - 1, qt, &(&1 + qt))
    end)
    |> pass_days(days_left - 1)
  end

  def parse_input(input) do
    input |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end
