# Cache is responsible to provide and store Todo.List PID's by name
#so that can many of them be managed simultaneously.
defmodule Todo.Cache do
  use GenServer

  @db_folder "./persist"

  def init(todo_list) do
    Todo.Database.start(@db_folder)
    {:ok, todo_list || Map.new}
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def start(todo_list) do
    GenServer.start(__MODULE__, todo_list)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        # Server exist, returns server PID
        {:reply, todo_server, todo_servers}
      :error ->
        # Server doesnt exist, create and return its PID
        {:ok, new_server} = Todo.Server.start(todo_list_name)
        {
          :reply,
          new_server,
          Map.put(todo_servers, todo_list_name, new_server)
        }
    end

  end
end
