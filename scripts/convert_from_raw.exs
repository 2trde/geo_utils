defmodule Helper do
  def split_csv(input, acc \\ "", in_quote \\ false)
  def split_csv("\"" <> rem, acc, false), do: split_csv(rem, acc, true)
  def split_csv("\"" <> rem, acc, true), do: split_csv(rem, acc, false)
  def split_csv("," <> rem, acc, true), do: split_csv(rem, "#{acc},", true)
  def split_csv("," <> rem, acc, false), do: [acc | split_csv(rem, "", false)]
  def split_csv(<< first::utf8, rem::binary>>, acc, in_quote), do: split_csv(rem, acc <> <<first::utf8>>, in_quote)
  def split_csv("", acc, _in_quote), do: [acc]

  def to_float(str) do
    if String.contains?(str, ".") do
      String.to_float(str)
    else
      String.to_integer(str)
    end
  end
end


File.ls!("data/raw")
#["zipcodes.pl.csv", "zipcodes.sk.csv", "zipcodes.dk.csv", "zipcodes.lt.csv", "zipcodes.pl.csv"]
|> Enum.map(fn file ->
  source_path = "data/raw/#{file}"
  country =
    Regex.run(~r/zipcodes\.([a-z]{2})/, file)
    |> case do
      [_, c] -> c
    end

  IO.puts "#{file}, #{country}"

  File.stream!(source_path)
  |> Stream.map(fn line ->
    line
    |> String.trim()
    |> Helper.split_csv()
    |> case do
      [_country, _zip, _place, _state, _state_code, _province, _provine_code, _community, _community_code, "latitude", _lon] ->
        nil
      [country, zip, _place, _state, _state_code, _province, _provine_code, _community, _community_code, lat, lon] ->
        [country <> "-" <> zip, Helper.to_float(lat), Helper.to_float(lon)]
    end
  end)
  |> Stream.filter(& &1)
  |> Enum.reduce(%{}, fn [zip, lat, lon], acc ->
    Map.get(acc, zip)
    |> case do
      nil ->
        acc |> Map.put(zip, [{lat, lon}])
      list ->
        Map.put(acc, zip, [{lat, lon} | list])
    end
  end)
  |> Enum.map(fn {zip, list} ->
    {lat_sum, lon_sum} = list |> Enum.reduce(fn {lat, lon}, {sum_lat, sum_lon} -> {lat+sum_lat, lon+sum_lon} end)
    len = length(list)
    {zip, {lat_sum / len, lon_sum / len}}
  end)
  |> Enum.map(fn {zip, {lat, lon}} -> "#{zip};#{lat};#{lon}" end)
  |> case do
    list ->
      File.write("data/zip_codes_#{country}.csv", list |> Enum.join("\n"))
  end
end)
