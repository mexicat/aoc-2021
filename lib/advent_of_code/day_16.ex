defmodule AdventOfCode.Day16 do
  def part1(input) do
    {val, _rest} =
      input
      |> parse_input()
      |> decode_packet()

    version_sum(val)
  end

  def decode_packets(<<>>), do: []

  def decode_packets(input) do
    {packet, rest} = decode_packet(input)
    [packet | decode_packets(rest)]
  end

  def decode_packet(<<version::3, 4::3, rest::bits>>) do
    {val, rest} = literal(rest, <<>>)
    {%{value: val, version: version}, rest}
  end

  def decode_packet(<<version::3, id::3, 0::1, sp_len::15, sp::bits-size(sp_len), rest::bits>>) do
    {%{value: decode_packets(sp), version: version}, rest}
  end

  def decode_packet(<<version::3, id::3, 1::1, sp_amt::11, rest::bits>>) do
    {val, rest} = decode_n_packets(rest, sp_amt, [])
    {%{value: val, version: version}, rest}
  end

  def decode_n_packets(rest, 0, acc), do: {Enum.reverse(acc), rest}

  def decode_n_packets(rest, n, acc) do
    {val, rest} = decode_packet(rest)
    decode_n_packets(rest, n - 1, [val | acc])
  end

  def literal(<<1::1, bits::4, rest::bits>>, acc), do: literal(rest, <<acc::bits, bits::4>>)
  def literal(<<0::1, bits::4, rest::bits>>, acc), do: {<<acc::bits, bits::4>>, rest}

  def version_sum(packet) do
    if is_list(packet.value) do
      packet.version + Enum.sum(Enum.map(packet.value, &version_sum/1))
    else
      packet.version
    end
  end

  def parse_input(input) do
    # input = "A0016C880162017C3686B18A3D4780"

    input
    |> String.trim()
    |> Base.decode16!()
  end
end
