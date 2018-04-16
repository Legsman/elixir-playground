# Responsible for storing TodoList in disk
defmodule Todo.Database do
  use GenServer

  @moduledoc """
    Process responsible for initializing database folder and workers to access it
  """

  @pool_size 3
  @db_folder "./persist"

  @doc """
    Initialize database folder and database workers depending of the amount
    specified in the @pool_size variable (default to 3)

    Along with status, returns a tuple containing the database folder and
    a zero-indexed based Map containing workers PID as values
  """
  def start do
    GenServer.start(__MODULE__, nil, name: :database_server)
  end

  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, init_database_workers()}
  end

  defp init_database_workers do
    Map.new(0..(@pool_size - 1), fn x ->
      {:ok, worker} = Todo.DatabaseWorker.start(@db_folder)
      {x, worker}
    end)
  end

  def store(key, data) do
    get_worker(key)
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    get_worker(key)
    |> Todo.DatabaseWorker.get(key)
  end

  @doc """
   Get database worker in intialized Map of Todo.Database for given key
   return a tuple containing the PID of the database worker, or nil if not found

   ## Examples
      iex> worker = Todo.Database.get_worker('hey')
      iex> is_pid(worker)
      true
  """
  def get_worker(key) do
    GenServer.call(:database_server, {:get_worker, key})
  end

  def handle_call({:get_worker, key}, _, workers) do
    data = case Map.fetch(workers, :erlang.phash2(key, 3)) do
      {:ok, worker} -> worker
      _ -> nil
    end

    {:reply, data, workers}
  end

end
