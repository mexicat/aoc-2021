defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Day07

  @input """
  16,1,2,0,4,2,7,1,2,14
  """

  # @tag :skip
  test "part1" do
    assert part1(@input) == 37
  end
end
