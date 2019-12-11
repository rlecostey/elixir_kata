defmodule PoemGenerator do
  def sliding_window_1(list, window_size) do
    Enum.chunk_every(list, window_size, 1, :discard)
  end
end
