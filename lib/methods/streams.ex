defmodule Streams do

  ##
  # line_lengths/1
  # Takes a file path and return a list of numbers, with each number representing the length
  # of the corresponding line from the file
  def line_lengths(path) do
    File.stream!(path)
    |> Enum.map(&String.length(&1))
  end

end
