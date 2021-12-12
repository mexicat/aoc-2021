defmodule AdventOfCode.Day12 do
  def part1(input) do
    input
    |> parse_input()
    |> find_path("start", ["start"])
    |> length()
  end

  def part2(input) do
    input
    |> parse_input()
    |> find_path_2("start", ["start"])
    |> length()
  end

  def find_path(caves, from, visited) do
    caves[from]
    |> Enum.reject(fn cave -> is_small(cave) and cave in visited end)
    |> Enum.flat_map(fn
      "end" ->
        [["end" | visited]]

      cave ->
        if is_small(cave) and cave in visited,
          do: visited,
          else: find_path(caves, cave, [cave | visited])
    end)
  end

  def find_path_2(caves, from, visited) do
    small_visited = visited |> Enum.filter(&is_small/1)
    conns = caves[from] |> Enum.reject(&(&1 == "start"))

    conns =
      if length(Enum.uniq(small_visited)) != length(small_visited),
        do: conns |> Enum.reject(fn cave -> is_small(cave) and cave in visited end),
        else: conns

    Enum.flat_map(conns, fn
      "end" -> [["end" | visited]]
      cave -> find_path_2(caves, cave, [cave | visited])
    end)
  end

  def is_small(cave), do: String.downcase(cave) == cave

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [from, to], acc ->
      acc
      |> Map.update(from, [to], &[to | &1])
      |> Map.update(to, [from], &[from | &1])
    end)
  end
end
