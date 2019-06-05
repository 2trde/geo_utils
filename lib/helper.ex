defmodule GeoUtils.Helper do
  defmacro gen_zip_to_coordinate(file, prefix, default \\ false) do
    to_float = fn
      s when is_binary(s) ->
        Regex.run(~r/\d+\.\d+/, s)
        |> case do
          [s] -> String.to_float(s)
          _ -> String.to_integer(s)
        end
      n when is_number(n) -> n
    end

    produce_code = fn(zip, lat, lon, acc) ->
      lat = to_float.(lat)
      lon = to_float.(lon)

      zip = prefix <> "-" <> zip
      if default do
        quote do
          unquote(acc)
          def zip_to_coordinate(unquote(zip)), do: %{lat: unquote(lat), lon: unquote(lon)}
        end
      else
        quote do
          unquote(acc)
          def zip_to_coordinate(unquote(zip)), do: %{lat: unquote(lat), lon: unquote(lon)}
        end
      end
    end

    File.read!(file)
    |> Poison.decode!()
    |> Enum.reduce(nil, fn
      {zip, %{"lat" => lat, "lon" => lon}}, acc ->
        produce_code.(zip, lat, lon, acc)
      %{"nr" => zip, "visueltcenter" => [lon, lat]}, acc ->
        produce_code.(zip, lat, lon, acc)
    end)
  end
end
