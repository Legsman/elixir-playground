defmodule Todo.DatabaseWorker do
  use GenServer
  @moduledoc """
    Process which performs database operations.
  """

  def init(db_folder) do
    {:ok, db_folder}
  end

  @doc """
    Start database process from Todo.Database
  """
  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  @doc """
    Asynchronously store data for given key onto todo database
  """
  def store(worker_pid, key, data) do
    GenServer.cast(worker_pid, {:store, key, data})
  end

  @doc """
    Synchronous call to get data for given key, return
    nil if not found
  """
  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
  end

  def handle_cast({:store, key, data}, db_folder) do
    file_name(db_folder, key)
    |> File.write!(:erlang.term_to_binary(data))
    {:noreply, db_folder}
  end

  def handle_call({:get, key}, _, db_folder) do
    data = case File.read(file_name(db_folder, key)) do
      # If found in file, convert binary contents to term
      {:ok, contents} -> :erlang.binary_to_term(contents)
      # Else, return nil
      _ -> nil
    end

    {:reply, data, db_folder}
  end

  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"
end
