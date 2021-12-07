defmodule AdventOfCode.Day03 do
  use Bitwise

  def part1(input) do
    gamma =
      input
      |> parse_input()
      |> Enum.zip()
      |> Enum.map(fn x ->
        x |> Tuple.to_list() |> Enum.frequencies() |> Enum.max_by(fn {_k, v} -> v end) |> elem(0)
      end)
      |> make_decimal()

    epsilon = ~~~gamma &&& 0xFFF

    gamma * epsilon
  end

  def part2(input) do
    numbers = input |> parse_input()
    len = numbers |> Enum.at(0) |> length()

    oxy = calc_rating(numbers, len, :max)
    co2 = calc_rating(numbers, len, :min)

    oxy * co2
  end

  def calc_rating(numbers, len, min_or_max) do
    Enum.reduce_while(0..len, numbers, fn i, acc ->
      best =
        acc
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.at(i)
        |> Enum.frequencies()
        |> Enum.sort(fn a, b ->
          if min_or_max == :max, do: sort_max(a, b), else: sort_min(a, b)
        end)
        |> Enum.at(0)
        |> elem(0)

      new_acc = Enum.filter(acc, &(Enum.at(&1, i) == best))

      case length(new_acc) do
        1 -> {:halt, Enum.at(new_acc, 0)}
        _ -> {:cont, new_acc}
      end
    end)
    |> make_decimal()
  end

  def make_decimal(binary_list), do: binary_list |> Enum.join() |> String.to_integer(2)

  def sort_max({k1, v1}, {k2, v2}) when v1 == v2, do: k1 > k2
  def sort_max({_k1, v1}, {_k2, v2}), do: v1 > v2

  def sort_min({k1, v1}, {k2, v2}) when v1 == v2, do: k1 < k2
  def sort_min({_k1, v1}, {_k2, v2}), do: v1 < v2

  def parse_input(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)
  end
end
