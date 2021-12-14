data =
  File.read!("data/zip_codes_de.json")
  |> Poison.decode!

list =
  data
  |> Enum.map(fn {zip, %{"lat" => lat, "lon" => lon}} ->
    ["DE-" <> zip, lat, lon]
    |> Enum.join(";")
  end)

File.write("data/zip_codes_de.csv", list|> Enum.join("\n"))

  
