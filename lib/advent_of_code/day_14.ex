defmodule AdventOfCode.Day14 do
  def part1(input) do
    {template, pairs} = parse_input(input)

    {min, max} =
      Enum.reduce(1..10, template, fn _, acc ->
        grow(acc, pairs, "")
      end)
      |> String.codepoints()
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  def part2(input) do
    {template, pairs} = parse_input(input)

    t = String.codepoints(template)
    letters = Enum.frequencies(t)

    polymer =
      t
      |> Enum.zip(tl(t))
      |> Enum.frequencies()
      |> Enum.map(fn {k, v} ->
        {k |> Tuple.to_list() |> Enum.join(), v}
      end)
      |> Map.new()

    {_, letters} =
      Enum.reduce(1..40, {polymer, letters}, fn _, {acc, letters} ->
        grow_2(acc, pairs, letters)
      end)

    {min, max} =
      letters
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  def grow_2(polymer, pairs, letters) do
    Enum.reduce(polymer, {polymer, letters}, fn {k, v}, {acc, letters} ->
      <<a::binary-size(1), b::binary-size(1)>> = k
      x = Map.get(pairs, k)

      acc =
        acc
        |> Map.update!(k, &(&1 - v))
        |> Map.update(a <> x, v, &(&1 + v))
        |> Map.update(x <> b, v, &(&1 + v))

      letters = letters |> Map.update(x, v, &(&1 + v))

      {acc, letters}
    end)
  end

  def grow(<<_::binary-size(1)>>, _, polymer), do: polymer

  def grow(<<a::binary-size(1), b::binary-size(1)>> <> rest, pairs, "") do
    x = Map.get(pairs, a <> b)
    grow(b <> rest, pairs, a <> x <> b)
  end

  def grow(<<a::binary-size(1), b::binary-size(1)>> <> rest, pairs, polymer) do
    x = Map.get(pairs, a <> b)
    grow(b <> rest, pairs, polymer <> x <> b)
  end

  def parse_input(input) do
    [template | rules] = input |> String.split("\n", trim: true)

    rules =
      rules
      |> Enum.map(fn rule ->
        [k, v] = String.split(rule, " -> ")
        {k, v}
      end)
      |> Map.new()

    {template, rules}
  end
end
