defmodule Todo.Server do
  use GenServer

  def init({name, todo_list}) do
    {:ok, {name, Todo.Database.get(name) || todo_list}}
  end

  def start(name) do
    GenServer.start(__MODULE__, {name, Todo.List.new})
  end

  def start(name, todo_list) do
    GenServer.start(__MODULE__, {name, todo_list})
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  def update_entry(todo_server, entry_id, update_fun) do
    GenServer.cast(todo_server, {:update_entry, entry_id, update_fun})
  end

  def delete_entry(todo_server, entry_id) do
    GenServer.cast(todo_server, {:delete_entry, entry_id})
  end

  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    # Persist the data in file database
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_cast({:update_entry, entry_id, update_fun}, {name, todo_list}) do
    new_state = Todo.List.update_entry(todo_list, entry_id, update_fun)
    # Persist the data in file database
    Todo.Database.store(name, new_state)
    {:noreply, {name, todo_list}}
  end

  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    new_state = Todo.List.delete_entry(todo_list, entry_id)
    # Persist the data in file database
    Todo.Database.store(name, new_state)
    {:noreply, {name, todo_list}}
  end

  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end
end
