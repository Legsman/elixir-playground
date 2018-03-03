defmodule MultiDict do

  # Initializer function
  def new, do: Map.new

  # Create higher-level abstraction over Map.add
  def add(map, key, val) do
    Map.update(map, key, [val], &[val | &1])
  end

  # Create higher-level abstraction over Map.get
  def get(map, key) do
    Map.get(map, key, [])
  end

end
