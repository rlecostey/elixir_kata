defmodule PoemGeneratorTest do
  use ExUnit.Case

  test "poem generator #1" do
    list = [0, 1, 2, 3, 4, 5]
    assert PoemGenerator.sliding_window_1(list, 3) == [[0, 1, 2], [1, 2, 3], [2, 3, 4], [3, 4, 5]]
  end
end
