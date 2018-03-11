defmodule TodoList.CsvImporter do

  def import(path) do
    path
    |> filtered_lines!
    |> create_entries!
    |> TodoList.new
  end

    defp filtered_lines!(path) do
      path
      |> File.stream!
      |> Stream.map(&String.replace(&1, "\n", ""))
    end

    defp create_entries!(lines) do
      lines
      |> Stream.map(&extract_fields/1)
      |> Stream.map(&create_entry/1)
    end

    defp extract_fields(line) do
      line
      |> String.split(",")
      |> convert_date
    end

    defp convert_date([date_string, title]) do
      # Parse date string and store both values in tuple
      {parse_date(date_string), title}
    end

    defp parse_date(date_string) do
      # Split date string and convert each number to integer
      [year, month, day] =
        date_string
        |> String.split("/")
        |> Enum.map(&String.to_integer/1)

      # Ensure converted date string is a correct Date
      {:ok, _} = Date.new(year, month, day)
      {year, month, day}
    end

    defp create_entry({date, title}) do
      # Create map from tuple
      %{date: date, title: title}
    end

end
