defmodule NGram do
  defstruct n: 2, model: []

  @doc ~S"""
  ## Examples
  iex> NGram.build_from_string("The blue sky is near the red koala near the blue sky", 2)
  %NGram{
    model: %{
      ["The", "blue"] => 1.0,
      ["blue", "sky"] => 1.0,
      ["is", "near"] => 1.0,
      ["koala", "near"] => 1.0,
      ["near", "the"] => 1.0,
      ["red", "koala"] => 1.0,
      ["sky", "is"] => 1.0,
      ["the", "blue"] => 0.5,
      ["the", "red"] => 0.5
    },
    n: 2
  }

  iex> NGram.build_from_string("The blue sky is near the red koala near the blue sky", 3)
  %NGram{
    model: %{
      ["The", "blue", "sky"] => 1.0,
      ["blue", "sky", "is"] => 1.0,
      ["is", "near", "the"] => 1.0,
      ["koala", "near", "the"] => 1.0,
      ["near", "the", "blue"] => 0.5,
      ["near", "the", "red"] => 0.5,
      ["red", "koala", "near"] => 1.0,
      ["sky", "is", "near"] => 1.0,
      ["the", "blue", "sky"] => 1.0,
      ["the", "red", "koala"] => 1.0
    },
    n: 3
  }
  """
  def build_from_string(string, n) do
    # Really basic tokenization on white spaces (not perfect but do the job)
    tokens = String.split(string, " ")

    # |> # Add magic here
    model = tokens |> sliding_window(n) |> ngram_probabilities(n)

    model = %NGram{n: n, model: model}
  end

  def build_from_file(data_path, n) do
    model =
      data_path
      |> File.stream!()
      # Remove unwanted special characters
      |> Stream.map(fn line -> String.replace(line, "\n", "") end)
      # Remove empty lines
      |> Stream.reject(&(&1 == ""))
      |> Stream.map(&(String.split(&1, " ") |> sliding_window(n)))
      # |> Stream.take(50) # <--- Useful to avoid reading the whole files for test purposes
      |> Enum.flat_map(& &1)

    # |> # Add magic here

    %NGram{n: n, model: model}
  end

  @doc ~S"""
  ## Examples
      iex> NGram.sliding_window([1, 2, 3, 4, 5, 6, 7], 5)
      [[1, 2, 3, 4, 5], [2, 3, 4, 5, 6], [3, 4, 5, 6, 7]]

      iex> NGram.sliding_window([1, 2, 3, 4, 5, 6, 7], 2)
      [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]

      iex> NGram.sliding_window([1, 2, 3, 4, 5, 6, 7], 1)
      [[1], [2], [3], [4], [5], [6], [7]]
  """
  def sliding_window(list, count) do
    Enum.chunk_every(list, count, 1, :discard)
  end

  defp ngram_probabilities(ngram_list, n) do
    Enum.reduce(ngram_list, %{}, fn ngram = [el | _], acc ->
      ngram_count = ngram_count(ngram, ngram_list)

      if n > 2 do
        bigram_count = bigram_count(Enum.take(ngram, 2), ngram_list)
        Map.put(acc, ngram, ngram_count / bigram_count)
      else
        el_count = el_count(el, ngram_list)
        Map.put(acc, ngram, ngram_count / el_count)
      end
    end)
  end

  defp ngram_count(ngram, ngram_list) do
    Enum.reduce(ngram_list, 0, fn ngram_element, count ->
      if ngram -- ngram_element == [] do
        count + 1
      else
        count
      end
    end)
  end

  defp el_count(el, ngram_list) do
    Enum.reduce(ngram_list, 0, fn ngram_element, count ->
      if el == List.first(ngram_element) do
        count + 1
      else
        count
      end
    end)
  end

  defp bigram_count(bigram, ngram_list) do
    Enum.reduce(ngram_list, 0, fn ngram_element, count ->
      if bigram -- Enum.take(ngram_element, 2) == [] do
        count + 1
      else
        count
      end
    end)
  end
end
