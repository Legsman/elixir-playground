defmodule RecursivesTest do
  use ExUnit.Case
  doctest Recursives

  test "list_len function calculates length of a list" do
    assert Recursives.list_len([1, :hey, 3, 6, 7]) == 5
    assert Recursives.list_len([]) == 0
  end
end
