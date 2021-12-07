defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  @input """
  3,4,3,1,2
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 5934
  end
end
