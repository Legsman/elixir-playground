defmodule Streams do

  require IEx

  ##
  # line_lengths/1
  # Takes a file path and return a list of numbers, with each number representing the length
  # of the corresponding line from the file
  def line_lengths(path) do
    filtered_lines!(path)
    |> Enum.map(&String.length(&1))
  end

  ##
  # longest_line_length/1
  # Returns the length of the longest line in a given file
  def longest_line_length(path) do
    filtered_lines!(path)
    |> Stream.map(&String.length(&1))
    |> Enum.max(fn -> nil end)
  end

  ##
  # longest_line/1
  # Returns the content of the longest line in a given file
  def longest_line(path) do
    filtered_lines!(path)
    # in this case, the longer_line function call result in longer_line(&1, ""),
    # with "" being the accumulator we've choosen, which will eventualy immediatly be replaced
    # by the first longer line with give and will become the new element of comparision while looping
    |> Enum.reduce("", &longer_line/2)
  end

  ##
  # words_per_line/1
  # Returns a list of numbers, with each numbers representing the word count for
  # each line of a file
  def words_per_line(path) do
    filtered_lines!(path)
    |> Stream.map(&String.split(&1))
    |> Enum.map(&length(&1))
  end

    defp filtered_lines!(path) do
      File.stream!(path)
      |> Stream.map(&String.replace(&1, "\n", ""))
    end

    defp longer_line(line1, line2) do
      if String.length(line1) > String.length(line2) do
        line1
      else
        line2
      end
    end
end
