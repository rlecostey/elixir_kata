defmodule NgramTest do
  use ExUnit.Case

  test "NGRAM build from string with Bi-gramme" do
    result = NGram.build_from_string("The blue sky is near the red koala near the blue sky", 2)

    assert result == %NGram{
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
  end

  test "NGRAM build from string with Tri-gramme" do
    result = NGram.build_from_string("The blue sky is near the red koala near the blue sky", 3)

    assert result == %NGram{
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
  end
end
