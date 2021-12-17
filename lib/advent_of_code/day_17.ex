defmodule AdventOfCode.Day17 do
  def part1(input) do
    {target_x, target_y} = target = parse_input(input)

    Enum.reduce(
      for(x <- 1..target_x.last, y <- -target_y.first..target_y.first, do: {x, y}),
      [],
      fn vel, acc ->
        case vel |> reaches_target(target) |> Enum.filter(&elem(&1, 0)) do
          [] -> acc
          l -> [l |> List.last() |> elem(1) | acc]
        end
      end
    )
    |> Enum.max()
  end

  def part2(input) do
    {target_x, target_y} = target = parse_input(input)

    Enum.reduce(
      for(x <- 1..target_x.last, y <- -target_y.first..target_y.first, do: {x, y}),
      0,
      fn vel, acc ->
        case vel |> reaches_target(target) |> Enum.filter(&elem(&1, 0)) do
          [] -> acc
          _ -> acc + 1
        end
      end
    )
  end

  def reaches_target(vel, target) do
    Stream.unfold({{0, 0}, vel, 0, false}, fn {pos, vel, max_y, reached_target} ->
      {new_pos, new_vel} = step(pos, vel)
      reached_target = if not reached_target, do: in_target(new_pos, target), else: false
      max_y = max(max_y, elem(new_pos, 1))

      case over_target(new_pos, target) do
        true -> nil
        false -> {{reached_target, max_y}, {new_pos, new_vel, max_y, reached_target}}
      end
    end)
  end

  def step({x, y}, {vel_x, vel_y}) do
    new_pos = {x + vel_x, y + vel_y}

    new_vel_x =
      cond do
        vel_x == 0 -> 0
        vel_x > 0 -> vel_x - 1
        vel_x < 0 -> vel_x + 1
      end

    new_vel_y = vel_y - 1

    {new_pos, {new_vel_x, new_vel_y}}
  end

  def in_target({x, y}, {range_x, range_y}) do
    x in range_x and y in range_y
  end

  def over_target({x, y}, {range_x, range_y}) do
    y < range_y.first or x > range_x.last
  end

  def parse_input(input) do
    [x, y] =
      input
      |> String.trim()
      |> String.trim_leading("target area: ")
      |> String.split(", ")

    [x1, x2] = x |> String.trim_leading("x=") |> String.split("..")
    [y1, y2] = y |> String.trim_leading("y=") |> String.split("..")

    {String.to_integer(x1)..String.to_integer(x2), String.to_integer(y1)..String.to_integer(y2)}
  end
end
