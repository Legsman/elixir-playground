defmodule Todo.Server do

  def start do
    spawn(fn -> loop(Todo.List.new) end)
  end

  defp loop(todo_list) do

  end

end
