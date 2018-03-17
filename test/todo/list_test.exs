defmodule Todo.List.Test do
  use ExUnit.Case
  doctest Todo.List

  test "can add and read entry to todo_list" do
    todo_list = Todo.List.new
    |> Todo.List.add_entry(%{ date: {2017, 09, 10}, title: "New Entry"})
    assert todo_list == %Todo.List{auto_id: 2, entries: %{1 => %{date: {2017, 9, 10}, id: 1, title: "New Entry"}}}
  end

  test "can read entries to todo_list" do
    entries = [
      %{ date: {2017, 09, 10}, title: "New Entry"},
      %{ date: {2017, 09, 11}, title: "New Entry 2"},
      %{ date: {2017, 09, 12}, title: "New Entry 3"}
    ]
    todo_list = Enum.reduce(entries, Todo.List.new, &Todo.List.add_entry(&2, &1))

    assert Todo.List.entries(todo_list, {2017, 9, 11}) == [%{date: {2017, 9, 11}, id: 2, title: "New Entry 2"}]
  end

  test "can update entry" do
    todo_list = Todo.List.new
    |> Todo.List.add_entry(%{ date: {2017, 09, 10}, title: "Old Entry"})

    assert Todo.List.update_entry(todo_list, 1, &Map.put(&1, :title, "New Entry")) == %Todo.List{auto_id: 2,
             entries: %{1 => %{date: {2017, 9, 10}, id: 1, title: "New Entry"}}}
  end

  test "can delete entry" do
    entries = [
      %{ date: {2017, 09, 10}, title: "New Entry"},
      %{ date: {2017, 09, 11}, title: "New Entry 2"}
    ]
    todo_list = Enum.reduce(entries, Todo.List.new, &Todo.List.add_entry(&2, &1))

    assert Todo.List.delete_entry(todo_list, 2) == %Todo.List{auto_id: 3, entries: %{1 => %{date: {2017, 9, 10}, id: 1, title: "New Entry"}}}
  end

  test "test protocol implentation for 'into' function for Todo.List" do
    entries = [
      %{ date: {2017, 09, 10}, title: "New Entry"},
      %{ date: {2017, 09, 11}, title: "New Entry 2"},
      %{ date: {2017, 09, 12}, title: "New Entry 3"}
    ]
    expected_result = %Todo.List{
      auto_id: 4,
      entries: %{
        1 => %{date: {2017, 9, 10}, id: 1, title: "New Entry"},
        2 => %{date: {2017, 9, 11}, id: 2, title: "New Entry 2"},
        3 => %{date: {2017, 9, 12}, id: 3, title: "New Entry 3"}
        }
      }

    todo_list = for entry <- entries, into: Todo.List.new, do: entry
    assert expected_result == todo_list
  end
end
