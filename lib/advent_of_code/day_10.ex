defmodule AdventOfCode.Day10 do
  @chunks %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&eval_line/1)
    |> Enum.filter(&(elem(&1, 0) == :error))
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  def part2(input) do
    results =
      input
      |> parse_input()
      |> Enum.map(&eval_line/1)
      |> Enum.filter(&(elem(&1, 0) == :ok))
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.sort()

    middle = results |> length() |> div(2)
    Enum.at(results, middle)
  end

  def eval_line(line, open \\ [])

  def eval_line([head | tail], open) when head in ["(", "[", "{", "<"] do
    eval_line(tail, [head | open])
  end

  def eval_line([head | tail], [open_head | open_tail]) do
    if head == @chunks[open_head] do
      eval_line(tail, open_tail)
    else
      {:error, score_error(head)}
    end
  end

  def eval_line(_, open) do
    score =
      Enum.reduce(open, 0, fn char, acc ->
        acc * 5 + score_ac(@chunks[char])
      end)

    {:ok, score}
  end

  def score_error(")"), do: 3
  def score_error("]"), do: 57
  def score_error("}"), do: 1197
  def score_error(">"), do: 25137

  def score_ac(")"), do: 1
  def score_ac("]"), do: 2
  def score_ac("}"), do: 3
  def score_ac(">"), do: 4

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
  end
end
