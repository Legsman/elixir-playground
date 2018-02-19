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
end
