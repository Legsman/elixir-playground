defmodule Todo.Server do

  def start do
    spawn(fn -> loop(Todo.List.new) end)
  end

  def start(todo_list) do
    spawn(fn -> loop(todo_list) end)
  end

  def add_entry(todo_server, new_entry) do
    send(todo_server, {:add_entry, new_entry})
  end

  # Since this function is a getter, it needs to implement a receiver to return
  # the requested message
  def entries(todo_server, date) do
    send(todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, entries} -> entries
    after 5000 ->
      {:error, :timeout}
    end
  end

  def update_entry(todo_server, entry_id, update_fun) do
    send(todo_server, {:update_entry, entry_id, update_fun})
  end

  def delete_entry(todo_server, entry_id) do
    send(todo_server, {:delete_entry, entry_id})
  end

  defp loop(todo_list) do
    new_todo_list = receive do
      message ->
        process_message(todo_list, message)
    end

    loop(new_todo_list)
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    Todo.List.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    # Since the "entries" method needs to return value, send back to result to the caller
    send(caller, {:todo_entries, Todo.List.entries(todo_list, date)})
    # The state has not changed since its only a getter method, so return the todo_list
    todo_list
  end

  defp process_message(todo_list, {:update_entry, entry_id, update_fun}) do
    Todo.List.update_entry(todo_list, entry_id, update_fun)
  end

  defp process_message(todo_list, {:delete_entry, entry_id}) do
    Todo.List.delete_entry(todo_list, entry_id)
  end

end
