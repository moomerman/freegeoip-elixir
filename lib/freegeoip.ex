defmodule FreeGeoIP do
  @moduledoc """
  A HTTP client for Quaderno API.
  """

  @default_base_url "http://freegeoip.net"

  use HTTPoison.Base

  @doc """
  Performs a IP search.

  ##Example result

  ```ex
  {:ok, ip_info} = FreeGeoIP.search
  ```

  ```ex
  %{
    ip: "192.30.252.128",
    country_code: "US",
    country_name: "Estados Unidos",
    region_code: "CA",
    region_name: "California",
    city: "San Francisco",
    zip_code: "94107",
    time_zone: "America/Los_Angeles",
    latitude: 37.7697,
    longitude: -122.3933,
    metro_code: 807
  } = ip_info
  ```

  In case of error:

  ```ex
  %{:error, "Format not supported. Use one of :csv, :xml, :json or :jsonp"}
  ```
  """
  def search(format, ip) do
    FreeGeoIP.Search.search(format, ip)
  end

  @doc """
  Grabs base_url from config (`config :freegeoip, base_url: CUSTOM_URL`) when using a custom hosted server. Defaults to public site `http://freegeoip.net`
  Returns binary
  """
  def config_base_url do
    Application.get_env(:freegeoip, :base_url) || System.get_env("FREEGEOIP_HOST") || @default_base_url
  end
  def config_auth_user do
    Application.get_env(:freegeoip, :auth_user) || System.get_env("FREEGEOIP_USER")
  end
  def config_auth_password do
    Application.get_env(:freegeoip, :auth_password) || System.get_env("FREEGEOIP_PASSWORD")
  end

  @doc """
  Boilerplate code to make requests with the key read from config or env.see config_or_env_key/0
  Args:
  * method - request method
  * endpoint - string requested API endpoint
  * body - request body
  * headers - request headers
  * options - request options
  Returns dict


  """
  def make_request( method, endpoint, body \\ []) do
    url = config_base_url <> endpoint

    headers = [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]

    headers = case auth_header(config_auth_user, config_auth_password) do
      nil -> headers
      auth -> [auth | headers]
    end

    case request(method, url, body, headers) do
      {:ok, response} ->
        case response.status_code do
          401 ->
            {:error, %{reason: :auth_failed, error: "freegeoip server requires basic auth credentials"}}
          200 ->
            case response.body do
              "Try again later\n" ->
                {:error, %{reason: :process_timeout, error: "freegeoip server seems to be oversaturated"}}
              body -> body
            end
          state ->
            {:error, %{reason: :invalid_state, error: "freegeoip request returned an invalid HTTP state: " <> state}}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{reason: reason, error: "error connecting to freegeoip server"}}
    end
  end

  #
  # Private
  #

  defp auth_header(username, password) do
    if (username && password) do
      encoded = Base.encode64("#{username}:#{password}")
      {"Authorization", "Basic #{encoded}"}
    end
  end

end
