defmodule AdventOfCode.Day16 do
  def part1(input) do
    {packet, _rest} =
      input
      |> parse_input()
      |> decode_packet()

    version_sum(packet)
  end

  def part2(input) do
    {packet, _rest} =
      input
      |> parse_input()
      |> decode_packet()

    eval(packet)
  end

  def decode_packets(<<>>), do: []

  def decode_packets(input) do
    {packet, rest} = decode_packet(input)
    [packet | decode_packets(rest)]
  end

  def decode_packet(<<version::3, 4::3, rest::bits>>) do
    {value, rest} = decode_literal(rest, <<>>)
    value_size = bit_size(value)
    <<value_int::size(value_size)>> = value
    {%{version: version, type: 4, value: value_int}, rest}
  end

  def decode_packet(<<version::3, type::3, 0::1, sp_len::15, sp::bits-size(sp_len), rest::bits>>) do
    value = decode_packets(sp)
    {%{version: version, type: type, value: value}, rest}
  end

  def decode_packet(<<version::3, type::3, 1::1, sp_amt::11, rest::bits>>) do
    {value, rest} = decode_n_packets(rest, sp_amt, [])
    {%{version: version, type: type, value: value}, rest}
  end

  def decode_n_packets(rest, 0, acc), do: {Enum.reverse(acc), rest}

  def decode_n_packets(rest, n, acc) do
    {value, rest} = decode_packet(rest)
    decode_n_packets(rest, n - 1, [value | acc])
  end

  def decode_literal(<<0::1, n::4, rest::bits>>, acc) do
    {<<acc::bits, n::4>>, rest}
  end

  def decode_literal(<<1::1, n::4, rest::bits>>, acc) do
    decode_literal(rest, <<acc::bits, n::4>>)
  end

  def version_sum(packet) do
    if is_list(packet.value) do
      packet.version + (packet.value |> Enum.map(&version_sum/1) |> Enum.sum())
    else
      packet.version
    end
  end

  def eval(%{type: 0, value: value}), do: value |> Enum.map(&eval/1) |> Enum.sum()
  def eval(%{type: 1, value: value}), do: value |> Enum.map(&eval/1) |> Enum.product()
  def eval(%{type: 2, value: value}), do: value |> Enum.map(&eval/1) |> Enum.min()
  def eval(%{type: 3, value: value}), do: value |> Enum.map(&eval/1) |> Enum.max()
  def eval(%{type: 4, value: value}), do: value
  def eval(%{type: 5, value: value}), do: value |> Enum.map(&eval/1) |> compare(&>/2)
  def eval(%{type: 6, value: value}), do: value |> Enum.map(&eval/1) |> compare(&</2)
  def eval(%{type: 7, value: value}), do: value |> Enum.map(&eval/1) |> compare(&==/2)

  def compare([a, b], fun) do
    if fun.(a, b), do: 1, else: 0
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> Base.decode16!()
  end
end
