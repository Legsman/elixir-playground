defmodule Discuss.UserView do
  use Discuss.Web, :view

  def first_name(%Discuss.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
