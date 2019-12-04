defmodule PoemGenerator do
  def sliding_window_1(list, window_size) do
    Enum.chunk_every(list, window_size)
  end

  def sliding_window_2(list, window_size) do
    Enum.reduce(list, [], fn el, acc ->
      IO.inspect(acc)
      last_list = List.last(acc)

      if last_list && Enum.count(last_list) < window_size do
        IO.puts("HERE")
        List.delete_at(acc, -1) ++ last_list ++ [el]
      else
        IO.puts("THERE")
        acc ++ [[el]]
      end
    end)
  end
end
