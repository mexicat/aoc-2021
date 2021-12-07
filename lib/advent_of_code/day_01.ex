defmodule AdventOfCode.Day01 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce({:infinity, 0}, fn x, {curr, tot} ->
      {x, if(x > curr, do: tot + 1, else: tot)}
    end)
    |> elem(1)
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.chunk_every(3, 1)
    |> Enum.reduce({:infinity, 0}, fn ns, {curr, tot} ->
      n_tot = Enum.sum(ns)
      {n_tot, if(n_tot > curr, do: tot + 1, else: tot)}
    end)
    |> elem(1)
  end

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
