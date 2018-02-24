defmodule StreamsTest do
  use ExUnit.Case
  import TestHelper
  doctest Streams

  test "line_lengths/1 function returns list of lengths of each line of a file" do
    assert Streams.line_lengths(csv_fixture("empty")) == []
    assert Streams.line_lengths(csv_fixture("lengthy")) == [203, 193, 100, 191, 197]
  end

  test "longest_line_length/1 function returns the length of longest line in a file" do
    assert Streams.longest_line_length(csv_fixture("empty")) == nil
    assert Streams.longest_line_length(csv_fixture("lengthy")) == 203
  end

end
