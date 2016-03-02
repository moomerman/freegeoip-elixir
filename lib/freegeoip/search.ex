defmodule FreeGeoIP.Search do
  @moduledoc """
  """

  @endpoint "authorization.json"

  @doc """
  Performs a IP search.

  ```ex
  {:ok, result} = FreeGeoIP.search(ip)
  ```

  ### Arguments

  * `ip`: can be either a stinrg or a tuple representing an IPv4 ip format
  * `locale`: (optional) localize the geolocation data. You can use [ISO 639-1 code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) or any string valid for a `Accept-language` HTTP header specification](https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html)

  ### Sample result

  ```ex
  %{
    "city" => "San Francisco",
    "country_code" => "US",
    "country_name" => "United States",
    "ip" => "192.30.252.128",
    "latitude" => 37.7697,
    "longitude" => -122.3933,
    "metro_code" => 807,
    "region_code" => "CA",
    "region_name" => "California",
    "time_zone" => "America/Los_Angeles",
    "zip_code" => "94107"
  }
  ```

  ### Errors:

  The errors will have the following format:

  ```ex
  %{:error, %{reason: reason, error: error_message}}
  ```

  `reason` can be one of the following:

  * `:auth_failed`: the server is protected with basic authentication and you have passed wrong credentials (see below for authentication)
  * `:process_timeout`: the server responded, but internally caused a timeout
  * `:timeout`: server did not respond in a few seconds
  * Any other reason given by the [HTTPoison.Error](https://hexdocs.pm/httpoison/HTTPoison.Error.html#content)
  * `:incorrect_ip_range`: incorrect IP provided (like 500.23.1100.32)
  * `:incorrect_ip_format`: specified IP format not supported. Use only string or tuple.


  """

  def search(ip, locale \\ nil)
  def search(ip, locale) when is_tuple(ip) do
    ip = ip |> Tuple.to_list |> Enum.join(".")
    search(ip, locale)
  end
  def search(ip, locale) when is_binary(ip) do
    if ip_valid?(ip) do
      case FreeGeoIP.make_request(:get, "/json/#{ip}", locale) do
        {:error, error} -> {:error, error}
        res             -> Poison.Parser.parse(res)
      end
    else
      {:error, %{reason: :incorrect_ip_range, error: "Incorrect IP. Please use IPv4 format"}}
    end
  end
  def search(ip, locale) do
    {:error, %{reason: :incorrect_ip_format, error: "IP format not supported. Please use string (\"1.2.3.4\") or tuple ({1, 2, 3, 4}) IPv4 format"}}
  end

  #
  # Private
  #

  defp ip_valid?(ip) do
    Regex.match?(~r/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/, ip)
  end

end