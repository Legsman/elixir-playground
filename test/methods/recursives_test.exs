defmodule RecursivesTest do
  use ExUnit.Case
  doctest Recursives

  test "list_len/1 function calculates length of a list" do
    assert Recursives.list_len([1, :hey, 3, 6, 7]) == 5
    assert Recursives.list_len([]) == 0
  end

  test "range/2 returns a list of all numbers in a given range" do
    assert Recursives.range(1, 5) == [1,2,3,4,5]
    assert Recursives.range(3, 0) == []
  end

  test "positive/1 returns list that contains only positive number for given list" do
    assert Recursives.positive([1, 5, -8, 3, -7]) == [1, 5, 8, 3, 7]
    assert Recursives.positive([]) == []
  end
end
