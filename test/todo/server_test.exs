defmodule Todo.Server.Test do
  use ExUnit.Case

  setup do
    {
      :ok,
      todo_server: Todo.Server.start,
      entries: [
        %{ date: {2017, 09, 10}, title: "New Entry"},
        %{ date: {2017, 09, 11}, title: "New Entry 2"},
        %{ date: {2017, 09, 12}, title: "New Entry 3"}
      ]
    }
  end

  test "can add to todo_list from Todo server", context do
    assert {:cast, {:add_entry, %{date: {2017, 9, 10}, title: "New Entry"}}} == Todo.Server.add_entry(context[:todo_server], %{ date: {2017, 09, 10}, title: "New Entry"})
  end

  test "can read entries of todo_list from Todo server", context do
    todo_server = Todo.Server.start(Todo.List.new(context[:entries]))
    assert [%{date: {2017, 9, 11}, id: 2, title: "New Entry 2"}] == Todo.Server.entries(todo_server, {2017, 9, 11})
  end

  test "can update entry of todo_list from Todo server", context do
    todo_server = Todo.Server.start(Todo.List.new(context[:entries]))
    assert {:cast, {:update_entry, 1, _ }} = Todo.Server.update_entry(todo_server, 1, &Map.put(&1, :title, "New Entry"))
  end

  test "can delete entry of todo_list from Todo server", context do
    todo_server = Todo.Server.start(Todo.List.new(context[:entries]))
    assert {:cast, {:delete_entry, 2}} == Todo.Server.delete_entry(todo_server, 2)
  end

end
