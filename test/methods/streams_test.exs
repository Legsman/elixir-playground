defmodule StreamsTest do
  use ExUnit.Case
  import TestHelper
  doctest Streams

  test "line_lengths/1 function returns list of lengths of each line of a file" do
    assert Streams.line_lengths(csv_fixture("empty")) == []
    assert Streams.line_lengths(csv_fixture("lengthy")) == [203, 193, 100, 191, 197]
  end

end
