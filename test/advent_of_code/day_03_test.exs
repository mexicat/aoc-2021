defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  @input """
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  """

  @tag :skip
  test "part1" do
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 5
  end
end
