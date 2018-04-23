defmodule Identicon do
  @moduledoc """
  Turn a string into an Identicon
  """

  def main(input) do
    input
    |> hash_input
  end

  @doc """
  Hash given string using md5 encryption, and insert the
  15 binaries produced into a list

    ## Examples
      iex> Identicon.hash_input('salut')
      [62, 215, 220, 234, 242, 102, 202, 254, 240, 50, 185, 213, 219, 34, 71, 23]
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end

end
