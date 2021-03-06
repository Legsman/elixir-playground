defmodule Identicon do
  require Integer
  @moduledoc """
  Turn a string into an Identicon (GitHub style!)
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
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

  @doc """
  Pick the 3 first elements of the Identicon.Image hex input, which
  represents the r, g and b colors, and store it in the color attr of the Image struct,
  which will be used to color each square of the Identicon
  returns the struct updated with the color picked

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
  Build the Image grid by splitting the hex list by chunk of 3
  and mirroring the 2 first elements of each chunks,
  Return the Image struct updated with the grid
  """
  def build_grid(%Identicon.Image{ hex: hex_list } = image) do
    grid =
      hex_list
      |> Stream.chunk_every(3)
      |> mirror_rows
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{ image | grid: grid }
  end

  defp mirror_rows(grid_list) do
    for [r, g, b] <- grid_list, do: [r, g, b, g, r]
  end

  @doc """
  Filter each square from the grid that represent an odd value,
  return the struct with updated grid
  """
  def filter_odd_squares(%Identicon.Image{ grid: grid } = image) do
    grid = Enum.filter(grid, fn({val, _index}) ->
      Integer.is_even(val)
    end)

    %Identicon.Image{ image | grid: grid }
  end

  @doc """
  Each square from the grid should be 50x50 tall and wide,
  this function calculates the x and y coordinates for each grid squares
  based on its index.

  Returns the Imager struct with the calculated pixel_map.
  """
  def build_pixel_map(%Identicon.Image{ grid: grid } = image) do
    pixel_map = Enum.map(grid, fn({_val, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end)

    %Identicon.Image{ image | pixel_map: pixel_map }
  end

  @doc """
  Draw the actual image (250x250 px) and use the Erlang drawing library
  to fill each squares of the pixel map with the color picked onto the image

  Return the image as binary, ready to be saved onto a file
  """
  def draw_image(%Identicon.Image{ color: color, pixel_map: pixel_map }) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Save image onto a file named by thed original input
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

end
