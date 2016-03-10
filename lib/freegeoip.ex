defmodule FreeGeoIP do
  @moduledoc """
  Simple Elixir wrapper for freegeoip.net HTTP API.

  This package allows to get geolocation information about a specified IP.
  """

  @default_base_url "http://freegeoip.net"

  use HTTPoison.Base

  @doc """
  Boilerplate code to make requests to freegeoip server specified whit the data read from config or system environment variables.

  Args:

  * method - request method
  * endpoint - string requested API endpoint
  * locale - specify language for getting results. This argument is converted directly into a `Àccept-language` HTTP header on the request.

  Returns dict
  """
  def make_request(method, endpoint, locale \\ nil, body \\ []) do
    url = config_base_url <> endpoint

    headers = set_headers(locale)

    case request(method, url, body, headers) do
      {:ok, response} -> process_response(response)
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{reason: reason, error: "error connecting to freegeoip server"}}
    end
  end

  #
  # Private
  #

  defp process_response(%{status_code: status_code, body: body}) do
    case status_code do
      401 ->
        {:error, %{reason: :auth_failed, error: "freegeoip server requires basic auth credentials"}}
      200 ->
        case body do
          "Try again later\n" ->
            {:error, %{reason: :process_timeout, error: "freegeoip server seems to be oversaturated"}}
          body -> body
        end
      status_code ->
        {:error, %{reason: :invalid_state, error: "freegeoip request returned an invalid HTTP status code: " <> to_string(status_code)}}
    end
  end

  defp auth_header(username, password) do
    if (username && password) do
      encoded = Base.encode64("#{username}:#{password}")
      {"Authorization", "Basic #{encoded}"}
    end
  end

  defp language_header(locale) do
    if locale do
      {"Accept-Language", locale}
    end
  end

  defp set_headers(locale) do
    headers = [
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]

    headers = case auth_header(config_auth_user, config_auth_password) do
      nil -> headers
      auth -> [auth | headers]
    end

    headers = case language_header(locale) do
      nil -> headers
      lang -> [lang | headers]
    end
  end

  defp config_base_url do
    Application.get_env(:freegeoip, :base_url) || System.get_env("FREEGEOIP_HOST") || @default_base_url
  end

  defp config_auth_user do
    Application.get_env(:freegeoip, :auth_username) ||
    Application.get_env(:freegeoip, :auth_user) ||
    System.get_env("FREEGEOIP_USERNAME") ||
    System.get_env("FREEGEOIP_USER")
  end

  defp config_auth_password do
    Application.get_env(:freegeoip, :auth_password) || System.get_env("FREEGEOIP_PASSWORD")
  end

end
