defmodule Identicon do
  @moduledoc """
  Turn a string into an Identicon (GitHub style!)
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  @doc """
  Pick the 3 first elements of the Identicon.Image hex input, which
  represents the r, g and b colors

    ## Examples
      iex> image = %Identicon.Image{hex: [62, 215, 220, 234, 242, 102, 202, 254, 240, 50, 185, 213, 219, 34, 71, 23]}
      iex> Identicon.pick_color(image)
      [62, 215, 220]
  """
  def pick_color(image) do
    %Identicon.Image{ hex: [r, g, b | _tail] } = image

    [r, g, b]
  end

  @doc """
  Hash given string using md5 encryption, and insert the
  15 binaries produced into an Image struct

    ## Examples
      iex> Identicon.hash_input('salut')
      %Identicon.Image{
        hex: [62, 215, 220, 234, 242, 102, 202, 254, 240, 50, 185, 213, 219, 34, 71, 23]
      }
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{ hex: hex }
  end

end
