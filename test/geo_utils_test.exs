defmodule GeoUtilsTest do
  use ExUnit.Case
  doctest GeoUtils
  import GeoUtils

  test "de is default" do
    assert zip_to_coordinate("DE-82294") == zip_to_coordinate("82294")
  end

  test "DE-82294" do
    assert zip_to_coordinate("DE-82294") == %{lat: 48.2333333, lon: 11.1666667}
  end

  test "DE-89077" do
    assert zip_to_coordinate("DE-89077") == %{lat: 48.4, lon: 10.0}
  end
end
