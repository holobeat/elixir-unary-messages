defmodule UnaryMessages do
  @moduledoc """
  Documentation for `UnaryMessages`.
  """

  @doc """
  Encode a message to unary code.

  ## Examples

      iex> UnaryMessages.send("Test")
      "0 0 00 0 0 0 00 0 0 0 00 00 0 00 00 00 0 0 00 0 0 0000 00 00 0 00000 00 0 0 0 00 00"

  """
  def send(s) do
    s
    |> String.to_charlist
    |> Enum.map(&(Integer.to_string(&1,2)))
    |> Enum.map(&(String.pad_leading(&1, 7, "0")))
    |> Enum.join
    |> String.to_charlist
    |> Enum.chunk_by(&(&1))
    |> Enum.map(&encode_chunk/1)
    |> Enum.join(" ")
  end

  @doc """
  Decode a message from unary code.

  ## Examples

      iex> UnaryMessages.receive("0 0 00 0 0 0 00 0 0 0 00 00 0 00 00 00 0 0 00 0 0 0000 00 00 0 00000 00 0 0 0 00 00")
      "Test"

  """
  def receive(s) do
    s
    |> String.to_charlist
    |> Enum.chunk_by(&(&1))
    |> Enum.filter(&(&1 != ' '))
    |> to_bin(true, nil, [])
    |> Enum.join
    |> String.to_charlist
    |> Enum.chunk_every(7)
    |> Enum.map(&(Integer.parse(List.to_string(&1), 2)))
    |> Enum.map(fn { n, _ } -> n end)
    |> List.to_string
  end
  
  defp encode_chunk([h|t]) do
    case h do
      ?1 -> '0 ' ++ List.duplicate(?0, length(t) + 1)
      ?0 -> '00 ' ++ List.duplicate(?0, length(t) + 1)
    end
  end
  
  defp to_bit(c), do: if c == '0', do: '1', else: '0'
  
  defp to_bin([], _, _, out), do: out
  defp to_bin([h|t], odd?, bit, out) do
    case odd? do
      true ->
        to_bin t, !odd?, to_bit(h), out
      false ->
        to_bin t, !odd?, bit, out ++ List.duplicate(bit, length(h))
    end
  end
    
end