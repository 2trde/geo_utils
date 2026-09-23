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
    assert prepare_zip("92-308A", "PL") == "92-308"
    assert prepare_zip("906 14", "SK") == "906 14"
    assert prepare_zip("90614", "SK") == "906 14"
    assert prepare_zip("4585-531", "PT") == "4585-531"
    assert prepare_zip("4585531", "PT") == "4585-531"
    assert prepare_zip("4585 531", "PT") == "4585-531"
    assert prepare_zip("747 81", "CZ") == "747 81"
    assert prepare_zip("74781", "CZ") == "747 81"
    assert prepare_zip("747-81", "CZ") == "747 81"
    assert prepare_zip("LV-4626", "LV") == "LV-4626"
    assert prepare_zip("LV 4626", "LV") == "LV-4626"
    assert prepare_zip("4626", "LV") == "LV-4626"
    assert prepare_zip("8938AD", "NL") == "8938"
    assert prepare_zip("8938AD", "NL") == "8938"
    assert prepare_zip("575 36", "SE") == "575 36"
    assert prepare_zip("575-36", "SE") == "575 36"
    assert prepare_zip("57536", "SE") == "575 36"
    assert prepare_zip("A-4863", "AT") == "4863"
    assert prepare_zip("L-4991", "LU") == "L-4991"
    assert prepare_zip("LU-4991", "LU") == "L-4991"
    assert prepare_zip("4991", "LU") == "L-4991"


  end

end
