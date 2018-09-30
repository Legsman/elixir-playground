defmodule Discuss.Repo do
  @moduledoc """
  In memory repository.
  """

  def all(Discuss.User) do
    [
      %Discuss.User{id: "1", name: "Antoine", username: "antoinemacia", password: "whatever"},
      %Discuss.User{id: "2", name: "Nicola", username: "nicolacollie", password: "colliemeow"},
      %Discuss.User{id: "3", name: "Josh", username: "ernestaines", password: "ernst"}
    ]
  end

  def all(_), do: []

  def get(module, id) do
    Enum.find(all(module), fn map -> map.id == id end)
  end

  def get_by(module, params) do
    Enum.find(all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end)
  end
end
