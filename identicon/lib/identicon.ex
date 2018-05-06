defmodule Identicon do
  @moduledoc """
  Turn a string into an Identicon (GitHub style!)
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
  Build the Image grid by splitting the hex list by chunk of 3
  and mirroring the 2 first elements of each chunks,
  Return the Image struct updated with the grid
  """
  def build_grid(%Identicon.Image{ hex: hex_list } = image) do
    grid =
      hex_list
      |> Enum.chunk_every(3)
      |> mirror_rows
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{ image | grid: grid }
  end

  defp mirror_rows(grid_list) do
    for [r, g, b] <- grid_list, do: [r, g, b, g, r]
  end

  @doc """
  Pick the 3 first elements of the Identicon.Image hex input, which
  represents the r, g and b colors, and store it in the color attr of the Image struct,
  returns the struct

    ## Examples
      iex> image = %Identicon.Image{hex: [62, 215, 220, 234, 242, 102, 202, 254, 240, 50, 185, 213, 219, 34, 71, 23]}
      iex> image = Identicon.pick_color(image)
      iex> image.color
      {62, 215, 220}
  """
  def pick_color(%Identicon.Image{ hex: [r, g, b | _tail] } = image) do
    %Identicon.Image{ image | color: {r, g, b} }
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
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list

    %Identicon.Image{ hex: hex }
  end

end
