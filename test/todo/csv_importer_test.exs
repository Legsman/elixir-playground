defmodule Todo.CsvImporter.Test do
  use ExUnit.Case
  import TestHelper
  doctest Todo.CsvImporter

  test "import entries from CSV" do
    expected_result = %Todo.List{
      auto_id: 4,
      entries: %{
        1 => %{date: {2013, 12, 19}, id: 1, title: "Dentist"},
        2 => %{date: {2013, 12, 20}, id: 2, title: "Shopping"},
        3 => %{date: {2013, 12, 19}, id: 3, title: "Movies"}
      }
    }
    assert expected_result == Todo.CsvImporter.import(csv_fixture("entries"))
  end
end
