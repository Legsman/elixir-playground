defmodule TodoListTest do
  use ExUnit.Case
  import TestHelper
  doctest TodoList

  test "can add and read entry to todo_list" do
    todo_list = TodoList.new
    |> TodoList.add_entry(%{ date: {2017, 09, 10}, title: "New Entry"})
    assert todo_list == %TodoList{auto_id: 2, entries: %{1 => %{date: {2017, 9, 10}, id: 1, title: "New Entry"}}}
  end

  test "can read entries to todo_list" do
    entries = [
      %{ date: {2017, 09, 10}, title: "New Entry"},
      %{ date: {2017, 09, 11}, title: "New Entry 2"},
      %{ date: {2017, 09, 12}, title: "New Entry 3"}
    ]
    todo_list = Enum.reduce(entries, TodoList.new, &TodoList.add_entry(&2, &1))

    assert TodoList.entries(todo_list, {2017, 9, 11}) == [%{date: {2017, 9, 11}, id: 2, title: "New Entry 2"}]
  end

  test "can update entry" do
    todo_list = TodoList.new
    |> TodoList.add_entry(%{ date: {2017, 09, 10}, title: "Old Entry"})

    assert TodoList.update_entry(todo_list, 1, &Map.put(&1, :title, "New Entry")) == %TodoList{auto_id: 2,
             entries: %{1 => %{date: {2017, 9, 10}, id: 1, title: "New Entry"}}}
  end
end
