defmodule FreeGeoIP.Search do
  @moduledoc """
  """

  @endpoint "authorization.json"
  @allowed_formats [:csv, :xml, :json, :jsonp]

  @doc """
  Called from FreeGeoIP.search
  """
  def search(format, ip) do
    if Enum.find(@allowed_formats, fn(f) -> f == format end) do
      if Regex.match?(~r/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/, ip) do
        _search(format, ip)
      else
        {:error, "IP format incorrect. Please use IPv4 format"}
      end
    else
      {:error, "Format not supported. Use one of :csv, :xml, :json or :jsonp"}
    end
  end

  #
  # Private
  #

  def _search(format, ip) do
    response = FreeGeoIP.make_request(:get, "/#{format}/#{ip}")
    case response do
      {:error, error} -> {:error, error}
      res             -> Poison.Parser.parse(res)
    end
  end

end