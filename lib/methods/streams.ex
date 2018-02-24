defmodule Streams do

  ##
  # line_lengths/1
  # Takes a file path and return a list of numbers, with each number representing the length
  # of the corresponding line from the file
  def line_lengths(path) do
    File.stream!(path)
    |> Enum.map(&String.length(&1))
  end

  ##
  # longest_line_length/1
  # Returns the length of the longest line in a given file
  def longest_line_length(path) do
    File.stream!(path)
    |> Stream.map(&String.length(&1))
    |> Enum.max(fn -> nil end)
  end
end
