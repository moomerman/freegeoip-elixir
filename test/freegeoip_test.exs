defmodule FreeGeoIPTest do
  use ExUnit.Case
  doctest FreeGeoIP

  @valid_ip "192.30.252.128"
  @invalid_ip "300.0.0.0"

  @valid_format :json
  @invalid_format :undefined

  test "FreeGeoIP base_url is defined" do
    assert(FreeGeoIP.config_base_url != nil)
    assert(FreeGeoIP.config_base_url != "")
  end

  test "Fails if not supported format" do
    assert {:error, _} = FreeGeoIP.search(@invalid_format, @valid_ip)
  end

  test "Fails if IP is invalid" do
    assert {:error, _} = FreeGeoIP.search(@valid_format, @invalid_ip)
  end

  test "Succesfully gets a result" do
    case FreeGeoIP.search(@valid_format, @valid_ip) do
      {:ok, res} -> assert(
        %{
          "city" => _,
          "country_code" => _,
          "country_name" => _,
          "ip" => _,
          "latitude" => _,
          "longitude" => _,
          "metro_code" => _,
          "region_code" => _,
          "region_name" => _,
          "time_zone" => _,
          "zip_code" => _
        } = res)
      {:error, %{error: err}} -> flunk err
    end
  end

end
