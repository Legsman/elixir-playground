defmodule Todo.Cache.Test do
  use ExUnit.Case

  setup do
    {
      :ok,
      todo_cache: Todo.Cache.start
    }
  end

  test "can start and retrieve Todo.List server via Todo.Cache", context do
    {:ok, cache_pid} = context[:todo_cache]
    new_server_pid = Todo.Cache.server_process(cache_pid, "Test list")
    # Assert server PID are identical if using the same key
    assert new_server_pid == Todo.Cache.server_process(cache_pid, "Test list")
    # Assert new server is created when key changes
    assert new_server_pid != Todo.Cache.server_process(cache_pid, "Test list 2")
  end

  test "persistence" do
    {:ok, cache} = Todo.Cache.start()

    test_list = Todo.Cache.server_process(cache, "Test list")
    Todo.Server.add_entry(test_list, %{date: {2017, 09, 10}, title: "whatever"})
    assert 1 == length(Todo.Server.entries(test_list, {2017, 09, 10}))

    GenServer.stop(cache)
    {:ok, cache} = Todo.Cache.start()

    entries =
      cache
      |> Todo.Cache.server_process("Test list")
      |> Todo.Server.entries({2017, 09, 10})

    assert [%{date: {2017, 09, 10}, title: "whatever"}] = entries
  end

end
