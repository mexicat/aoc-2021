defmodule AdventOfCode.Day04 do
  def part1(input) do
    {draws, boards} = parse_input(input)

    {winner, last_draw} =
      Enum.reduce_while(draws, boards, fn draw, acc ->
        new_acc =
          Enum.map(acc, fn board ->
            case Enum.find_index(board, &(&1 == draw)) do
              nil -> board
              x -> List.replace_at(board, x, "X")
            end
          end)

        case check_winning(new_acc) do
          [] -> {:cont, new_acc}
          x -> {:halt, {hd(x), draw}}
        end
      end)

    (winner |> Enum.filter(&(&1 != "X")) |> Enum.map(&String.to_integer/1) |> Enum.sum()) *
      String.to_integer(last_draw)
  end

  def part2(input) do
    {draws, boards} = parse_input(input)

    {_, winners, last_draw} =
      Enum.reduce(draws, {boards, [], nil}, fn draw, {acc, winners, last_draw} ->
        new_acc =
          Enum.map(acc, fn board ->
            case Enum.find_index(board, &(&1 == draw)) do
              nil -> board
              x -> List.replace_at(board, x, "X")
            end
          end)

        case check_winning(new_acc) do
          [] ->
            {new_acc, winners, last_draw}

          ws ->
            new_acc = Enum.reduce(ws, new_acc, fn w, acc -> List.delete(acc, w) end)
            {new_acc, Enum.concat(ws, winners), draw}
        end
      end)

    winner = hd(winners)

    (winner |> Enum.filter(&(&1 != "X")) |> Enum.map(&String.to_integer/1) |> Enum.sum()) *
      String.to_integer(last_draw)
  end

  def check_winning(boards) do
    Enum.filter(boards, fn board ->
      combs = [
        [0, 1, 2, 3, 4],
        [5, 6, 7, 8, 9],
        [10, 11, 12, 13, 14],
        [15, 16, 17, 18, 19],
        [20, 21, 22, 23, 24]
      ]

      zipped = combs |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
      combs = Enum.concat(combs, zipped)

      Enum.any?(combs, fn [a, b, c, d, e] ->
        Enum.at(board, a) == "X" &&
          Enum.at(board, b) == "X" &&
          Enum.at(board, c) == "X" &&
          Enum.at(board, d) == "X" &&
          Enum.at(board, e) == "X"
      end)
    end)
  end

  def parse_input(input) do
    [draws | boards] = String.split(input, "\n\n", trim: true)
    draws = String.split(draws, ",", trim: true)
    boards = Enum.map(boards, &String.split/1)
    {draws, boards}
  end
end
