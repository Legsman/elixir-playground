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
    {:ok, pid} = context[:todo_server]
    # Add the new entry asynchronously
    assert :ok == Todo.Server.add_entry(pid, %{ date: {2017, 09, 10}, title: "New Entry"})
    # Ensure the entry has correctly been added
    assert [%{date: {2017, 9, 10}, id: 1, title: "New Entry"}] == Todo.Server.entries(pid, {2017, 09, 10})
  end

  test "can read entries of todo_list from Todo server", context do
    {:ok, pid} = Todo.Server.start(Todo.List.new(context[:entries]))
    assert [%{date: {2017, 9, 11}, id: 2, title: "New Entry 2"}] == Todo.Server.entries(pid, {2017, 9, 11})
  end

  test "can update entry of todo_list from Todo server", context do
    {:ok, pid} = Todo.Server.start(Todo.List.new(context[:entries]))
    assert :ok = Todo.Server.update_entry(pid, 1, &Map.put(&1, :title, "New"))
  end

  test "can delete entry of todo_list from Todo server", context do
    {:ok, pid} = Todo.Server.start(Todo.List.new(context[:entries]))
    assert :ok == Todo.Server.delete_entry(pid, 2)
  end

end
