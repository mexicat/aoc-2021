defmodule AdventOfCode.Day02 do
  def part1(input) do
    {hor, dep} = input |> parse_input() |> Enum.reduce({0, 0}, &move/2)
    hor * dep
  end

  def part2(input) do
    {hor, dep, _aim} = input |> parse_input() |> Enum.reduce({0, 0, 0}, &move_2/2)
    hor * dep
  end

  def move({:up, x}, {hor, dep}), do: {hor, dep - x}
  def move({:down, x}, {hor, dep}), do: {hor, dep + x}
  def move({:forward, x}, {hor, dep}), do: {hor + x, dep}

  def move_2({:down, x}, {hor, dep, aim}), do: {hor, dep, aim + x}
  def move_2({:up, x}, {hor, dep, aim}), do: {hor, dep, aim - x}
  def move_2({:forward, x}, {hor, dep, aim}), do: {hor + x, dep + aim * x, aim}

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [d, x] -> {String.to_atom(d), String.to_integer(x)} end)
  end
end
