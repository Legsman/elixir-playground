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

end
