defmodule GeoUtilsTest do
  use ExUnit.Case
  doctest GeoUtils
  import GeoUtils

  test "de is default" do
    assert zip_to_coordinate("DE-82294") == zip_to_coordinate("82294")
  end

  test "DE-82294" do
    assert zip_to_coordinate("DE-82294") == %{lat: 48.2382, lon: 11.1557}
  end

  test "DE-89077" do
    assert zip_to_coordinate("DE-89077") == %{lat: 48.3981, lon: 9.97}
  end

  test "nil" do
    assert zip_to_coordinate(nil) == nil
  end


  test "prepare_zip" do
    assert prepare_zip("7773NK", "NL") == "7773"
  end
end
