defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  import AdventOfCode.Day01

  @input """
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 7
  end

  # @tag :skip
  test "part2" do
    assert part2(@input) == 5
  end
end
