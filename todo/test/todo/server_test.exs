defmodule Todo.Server.Test do
  use ExUnit.Case

  setup do
    on_exit(fn ->
      File.rm_rf("./persist")
      File.mkdir_p("./persist")
    end)
    {
      :ok,
      todo_cache: Todo.Cache.start,
      todo_list_name: "todo_list_test",
      entries: [
        %{ date: {2017, 09, 10}, title: "New Entry"},
        %{ date: {2017, 09, 11}, title: "New Entry 2"},
        %{ date: {2017, 09, 12}, title: "New Entry 3"}
      ]
    }
  end

  test "can add to todo_list from Todo server", context do
    {:ok, cache_pid} = context[:todo_cache]
    server_pid = Todo.Cache.server_process(cache_pid, context[:todo_list_name])
    # Add the new entry asynchronously
    assert :ok == Todo.Server.add_entry(server_pid, %{ date: {2017, 09, 10}, title: "New Entry"})
    # Ensure the entry has correctly been added
    assert [%{date: {2017, 9, 10}, id: 1, title: "New Entry"}] == Todo.Server.entries(server_pid, {2017, 09, 10})
    GenServer.stop(server_pid)
  end

  test "can read entries of todo_list from Todo server", context do
    {:ok, server_pid} = Todo.Server.start(context[:todo_list_name], Todo.List.new(context[:entries]))
    assert [%{date: {2017, 9, 11}, id: 2, title: "New Entry 2"}] == Todo.Server.entries(server_pid, {2017, 9, 11})
    GenServer.stop(server_pid)
  end

  test "can update entry of todo_list from Todo server", context do
    {:ok, cache_pid} = Todo.Cache.start(Todo.List.new(context[:entries]))
    server_pid = Todo.Cache.server_process(cache_pid, context[:todo_list_name])
    assert :ok = Todo.Server.update_entry(server_pid, 1, &Map.put(&1, :title, "New"))
    GenServer.stop(server_pid)
  end

  test "can delete entry of todo_list from Todo server", context do
    {:ok, cache_pid} = Todo.Cache.start(Todo.List.new(context[:entries]))
    server_pid = Todo.Cache.server_process(cache_pid, context[:todo_list_name])
    assert :ok == Todo.Server.delete_entry(server_pid, 2)
    GenServer.stop(server_pid)
  end

end
