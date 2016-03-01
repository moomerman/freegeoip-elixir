defmodule FreeGeoIP.Search do
  @moduledoc """
  """

  @endpoint "authorization.json"

  @doc """
  Performs a IP search.

  ```ex
  {:ok, result} = FreeGeoIP.search(ip)
  ```

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


  """
  def search(ip, locale \\ nil) do
    if ip_valid?(ip) do
      case FreeGeoIP.make_request(:get, "/json/#{ip}", locale) do
        {:error, error} -> {:error, error}
        res             -> Poison.Parser.parse(res)
      end
    else
      {:error, "IP format incorrect. Please use IPv4 format"}
    end
  end

  #
  # Private
  #

  defp ip_valid?(ip) do
    Regex.match?(~r/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/, ip)
  end

end