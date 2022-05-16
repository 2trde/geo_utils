[_header | rows] =
  File.read!("raw_data/georef-netherlands-postcode-pc4.csv")
  |> String.split("\n")

rows =
  rows
  |> Enum.map(fn line ->
    line
    |> String.split(";")
    |> case do
      [lat_lon, _coordinates, zip | _] ->
        [lat, lon] = lat_lon |> String.split(",")
        ["NL-#{zip}", lat, lon]
      line ->
        nil
    end
  end)
  |> Enum.filter(& &1)
  |> Enum.map(& Enum.join(&1, ";"))

data = rows |> Enum.join("\n")
File.write!("data/zip_codes_nl.csv", data)
