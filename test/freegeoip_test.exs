defmodule FreeGeoIPTest do
  use ExUnit.Case
  doctest FreeGeoIP

  @valid_ip "192.30.252.128"
  @valid_ip_tuple {192, 30, 252, 128}

  @invalid_ip "300.0.0.0"
  @invalid_ip_format :"192_30_252_128"

  test "Fails if IP is invalid" do
    assert {:error, _} = FreeGeoIP.Search.search(@invalid_ip)
  end

  test "Succesfully gets a result" do
    case FreeGeoIP.Search.search(@valid_ip) do
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

  test "Succesfully gets a result with specified locale" do
    case FreeGeoIP.Search.search(@valid_ip, "en") do
      {:ok, res} -> assert(%{"country_name" => "United States"} = res)
      {:error, %{error: err}} -> flunk err
    end

    case FreeGeoIP.Search.search(@valid_ip, "es") do
      {:ok, res} -> assert(%{"country_name" => "Estados Unidos"} = res)
      {:error, %{error: err}} -> flunk err
    end
  end

  test "Succesfully gets a result with tuple format" do
    case FreeGeoIP.Search.search(@valid_ip_tuple) do
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

  test "Fails if an invalid IP format is provided" do
    result = FreeGeoIP.Search.search(@invalid_ip_format)
    assert({:error, %{reason: :incorrect_ip_format}} = result)
  end


end
