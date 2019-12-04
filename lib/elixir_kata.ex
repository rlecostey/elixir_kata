defmodule ElixirKata do
  @moduledoc """
  Documentation for ElixirKata.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ElixirKata.hello()
      :world

  """
  def reverse_string_1(string) do
    String.reverse(string)
  end

  def reverse_string_2(string) do
    string
    |> String.codepoints
    |> Enum.reduce([], fn(el, acc) ->
      List.insert_at(acc, 0, el)
    end)
    |> Enum.join
  end

  def reverse_string_3(string) do
    string
    |> String.codepoints
    |> Enum.reverse(string)
    |> Enum.join
  end

  def reverse_string_4(string) do
    string
    |> String.codepoints
    |> Enum.reduce("", fn(el, acc) ->
      el <> acc
    end)
  end

end
