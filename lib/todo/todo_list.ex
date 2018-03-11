defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new
  # Initializer function, can accept multiple entries via a list
  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, &add_entry(&2, &1))
  end

  def add_entry(%TodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do
    # Add :id to entry which should be a date
    entry = Map.put(entry, :id, auto_id)
    # Add new entry to entries list
    new_entries = Map.put(entries, auto_id, entry)
    # Return TodoList with updated entries and incremented auto_id
    %TodoList{ todo_list | entries: new_entries, auto_id: auto_id + 1 }
  end

  def update_entry(%TodoList{entries: entries} = todo_list, entry_id, update_fun) do
    case entries[entry_id] do
      # Returns the unchanged list if entry not found
      nil -> todo_list
      old_entry ->
        # Nested pattern matching - This ensure the new_entry is a map with the same id as the old entry
        new_entry = %{id: ^entry_id} = update_fun.(old_entry)
        # Add new entry to entries list
        new_entries = Map.put(entries, new_entry.id, new_entry)
        # Returns TodoList with updated entries
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(%TodoList{entries: entries} = todo_list, entry_id) do
    case entries[entry_id] do
      # Returns the unchanged list if entry not found
      nil -> todo_list
      old_entry ->
        # Delete entry using entry id if found
        new_entries = Map.delete(entries, old_entry.id)
        # Returns TodoList with updated entries
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def entries(%TodoList{entries: entries}, date) do
    entries
    # First find the entries for date given
    |> Stream.filter(fn({_, entry}) ->
      entry.date == date
    end)
    # Return the entries found as a List
    |> Enum.map(fn({_, entry}) ->
      entry
    end)
  end

end
