defmodule AdventOfCode.Day07 do
  def part1(input) do
    crabs = parse_input(input)
    {min, max} = Enum.min_max(crabs)

    min..max
    |> Enum.map(fn pos ->
      crabs
      |> Enum.map(fn crab -> abs(crab - pos) end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def part2(input) do
    crabs = parse_input(input)
    {min, max} = Enum.min_max(crabs)

    min..max
    |> Enum.map(fn pos ->
      crabs
      |> Enum.map(fn crab ->
        n = abs(crab - pos)
        n * (n + 1) / 2
      end)
      |> Enum.sum()
    end)
    |> Enum.min()
  end

  def parse_input(input) do
    input |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)
  end
end
