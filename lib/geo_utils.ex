defmodule GeoUtils do
  @moduledoc """
  Helper to map plz to geocoordinates and calculate distances
  """



  def get_csv_path() do
    [
      "deps/geo_utils/data/zip_codes_de.csv",
      "data/zip_codes_de.csv"
    ]
    |> Enum.reduce(fn (path, acc) ->
      if File.exists?(path) do
        path
      else
        acc
      end
    end)
  end

  def zip_to_coordinate(<< _ :: utf8, _ :: utf8, _ :: utf8, _ :: utf8, _ :: utf8 >> = zip) do
    zip_to_coordinate("DE-" <> zip)
  end

  def zip_to_coordinate(zip) do
    File.stream!(get_csv_path(), [:read], :line)
    |> Stream.map(fn
      line ->
        if String.starts_with?(line, zip) do
          line
          |> String.trim()
          |> String.split(";")
          |> case do
            [_zip, lat, lon] ->
              %{lat: lat|>String.to_float, lon: lon|>String.to_float}
          end
        else
          nil
        end
    end)
    |> Stream.filter(& &1)
    |> Enum.into([])
    |> case do
      [coord] -> coord
      [] -> nil
    end
  end

  def distance(v1, v2) when is_nil(v1) or is_nil(v2), do: nil

  def distance(zip1, zip2) when is_binary(zip1) and is_binary(zip2) do
    distance(zip_to_coordinate(String.trim(zip1)), zip_to_coordinate(String.trim(zip2)))
  end

  def distance(%{lat: _, lon: _} = pos1, %{lat: _, lon: _} = pos2) when is_map(pos1) and is_map(pos2) do
    g1 = to_grid(pos1)
    g2 = to_grid(pos2)
    calc_dist(g1, g2)
  end

  def to_grid(%{lat: lat, lon: lon}) do
    g_y = lat * 60 * 1.852
    g_x = lon * 60 * 1.852 * 0.6560
    %{x: g_x, y: g_y}
  end
  def to_grid(_), do: nil

  def calc_dist(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    dx = x2 - x1
    dy = y2 - y1
    :math.sqrt(dx*dx + dy*dy)
  end
end
