defmodule GeoUtils.Helper do
  defmacro gen_zip_to_coordinate() do
    to_float = fn
      s when is_binary(s) ->
        Regex.run(~r/\d+\.\d+/, s) 
        |> case do
          [s] -> String.to_float(s)
          _ -> String.to_integer(s)
        end
      n when is_number(n) -> n
    end
    File.read!("data/zip_codes_de.json")
    |> Poison.decode!()
    |> Enum.reduce(nil, fn {zip, %{"lat" => lat, "lon" => lon}}, acc ->
      lat = to_float.(lat)
      lon = to_float.(lon)
      
      quote do
        unquote(acc)
        def zip_to_coordinate(unquote(zip)), do: %{lat: unquote(lat), lon: unquote(lon)}
      end
    end)
  end
end
