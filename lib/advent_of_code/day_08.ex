defmodule AdventOfCode.Day08 do
  @mapp %{
    0 => 6,
    1 => 2,
    2 => 5,
    3 => 5,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 3,
    8 => 7,
    9 => 6
  }

  def part1(input) do
    freqs =
      input
      |> parse_input()
      |> Enum.map(&Enum.take(&1, -4))
      |> List.flatten()
      |> Enum.map(&String.length/1)
      |> Enum.frequencies()

    freqs[@mapp[1]] + freqs[@mapp[4]] + freqs[@mapp[7]] + freqs[@mapp[8]]
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.map(fn row ->
      Enum.map(row, fn chars ->
        chars |> String.codepoints() |> Enum.sort()
      end)
    end)
    |> Enum.map(&decode_line/1)
    |> Enum.sum()
  end

  def decode_line(line) do
    one = Enum.find(line, &(length(&1) == @mapp[1]))
    four = Enum.find(line, &(length(&1) == @mapp[4]))
    seven = Enum.find(line, &(length(&1) == @mapp[7]))
    eight = Enum.find(line, &(length(&1) == @mapp[8]))

    zero_six_nine = Enum.filter(line, &(length(&1) == @mapp[0]))
    nine = Enum.find(zero_six_nine, fn n -> four -- n == [] end)
    zero_six = zero_six_nine -- [nine]
    zero = Enum.find(zero_six, fn n -> seven -- n == [] end)
    six = hd(zero_six -- [zero])

    two_three_five = Enum.filter(line, &(length(&1) == @mapp[2]))
    three = Enum.find(two_three_five, fn n -> seven -- n == [] end)
    two_five = two_three_five -- [three]
    five = Enum.find(two_five, fn n -> n -- six == [] end)
    two = hd(two_five -- [five])

    new_mapp = %{
      zero => 0,
      one => 1,
      two => 2,
      three => 3,
      four => 4,
      five => 5,
      six => 6,
      seven => 7,
      eight => 8,
      nine => 9
    }

    line
    |> Enum.take(-4)
    |> Enum.map(fn x -> new_mapp[x] end)
    |> Enum.join()
    |> String.to_integer()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, [" ", " | "], trim: true))
  end
end
