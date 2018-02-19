defmodule Recursives do

  ##
  # Function that calculates the length of a list
  def list_len(list) do
    sum_length(0, list)
  end

  ### PRIVATE

    defp sum_length(sum, []), do: sum

    defp sum_length(sum, [_head | tail]) do
      sum + 1
      |> sum_length(tail)
    end

end
