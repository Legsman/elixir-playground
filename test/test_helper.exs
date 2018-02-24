defmodule TestHelper do

  def csv_fixture(path) do
    "test/fixtures/csv/#{path}.csv"
  end
end

ExUnit.start()
