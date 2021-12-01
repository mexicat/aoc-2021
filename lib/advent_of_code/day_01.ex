defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce({0, 0}, fn x, {curr, tot} ->
      {x, if(x > curr, do: tot + 1, else: tot)}
    end)
    |> elem(1)
    |> Kernel.-(1)
  end

  def part2(input) do
    numbers = input |> parse_input()
    numbers_2 = numbers |> Enum.drop(1)
    numbers_3 = numbers_2 |> Enum.drop(1)

    Enum.zip_reduce([numbers, numbers_2, numbers_3], {0, 0}, fn ns, {curr, tot} ->
      n_tot = Enum.sum(ns)
      {n_tot, if(n_tot > curr, do: tot + 1, else: tot)}
    end)
    |> elem(1)
    |> Kernel.-(1)
  end

  def parse_input(input) do
    input |> String.trim() |> String.split("\n") |> Enum.map(&String.to_integer/1)
  end
end
