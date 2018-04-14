defmodule Recursives do

  ##
  # list_len/1
  # Function that calculates the length of a list

  def list_len(list) do
    sum_length(0, list)
  end

  defp sum_length(sum, []), do: sum

  defp sum_length(sum, [_head | tail]) do
    sum + 1
    |> sum_length(tail)
  end

  ##
  # range/2
  # Function that takes 2 integers and returns a list of all numbers in a given range

  def range(from, to) do
    make_range(from, to, [])
  end

  # At this point we have the result
  defp make_range(from, to, result) when from > to do
    result
  end

  defp make_range(from, to, result) do
    # - We first prepend `to` to the top of the accumulated list.
    # - Then, we just loop the recursion with decremented `to`.
    # - Since this is the last thing done in the function, it's a tail-recursive
    #   call.
    # - Since we continuously prepend decrementing `to`s to the result, we'll
    #   get the result in the proper order.
    make_range(from, to - 1, [to | result])
  end

  ##
  # positive/1
  # Function that takes a list and returns another list that contains only positive
  # numbers from the input list
  def positive(list) do
    convert_to_positive(list, [])
  end

  # At this point we have the result, or if list provided empty
  defp convert_to_positive([], positives), do: Enum.reverse(positives)

  # Prepend absolute number of provided list head to positives
  defp convert_to_positive([head | tail], positives) do
    convert_to_positive(tail, [abs(head) | positives])
  end

end
