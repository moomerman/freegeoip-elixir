# Freegeoip 
[![Build Status](https://travis-ci.org/juljimm/freegeoip-elixir.svg?branch=master)](https://travis-ci.org/juljimm/freegeoip-elixir)
[![Coverage Status](https://coveralls.io/repos/github/juljimm/freegeoip-elixir/badge.svg?branch=master)](https://coveralls.io/github/juljimm/freegeoip-elixir?branch=master)
[![Inline docs](http://inch-ci.org/github/juljimm/freegeoip-elixir.svg)](http://inch-ci.org/github/juljimm/freegeoip-elixir)


Simple Elixir wrapper for freegeoip.net HTTP API.

This package allows to get geolocation information about a specified IP.

## Usage

```ex
  {:ok, result} = FreeGeoIP.Search.search("192.30.252.128")
```
or

```ex
  {:ok, result} = FreeGeoIP.Search.search({192, 30, 252, 128})
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

### Errors

You can receive mutiple errors, check [the documentation](https://hexdocs.pm/freegeoip) for details:

```ex
%{:error, %{reason: :some_error, error: "some error description"}}
```

### Localizing results

You can specify the language you want the results to be. Just use the [ISO 639-1 code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) of the desired language.

```ex
FreeGeoIP.Search.search(ip, "es")
```

You can also put the locale as a string, using the same format as used on [`Accept-language` HTTP header specification](https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html):

```ex
FreeGeoIP.Search.search(ip, "da, en-gb;q=0.8, en;q=0.7")
``` 


## Using a custom server

You can use a custom hosted freegeoip server. I personally don't recommend using the public server for production because is normally oversaturated, causing many requests to time out.

For instructions to install your own server check [freegeoip project](https://github.com/fiorix/freegeoip#running).

Once installed, you can specify the server base URL by setting `FREEGEOIP_HOST` environment variable:

```bash
export FREEGEOIP_HOST=http://my_own_server.com
``` 

Alternatively you can set the server host in your `config.exs` file:

```ex
use Mix.Config

config :freegeoip, base_url: "http://mydomain.com"
```

### Server authentication

If you choose to protect your server with basic authentication you can specify username and password the same way you set the server host, this time using `FREEGEOIP_USERNAME`and `FREEGEOIP_PASSWORD` env variables:

```bash
export FREEGEOIP_USERNAME=your_username
export FREEGEOIP_PASSWORD=your_password
``` 

Alternatively you can include this data into your server host in your `config.exs` file:

```ex
use Mix.Config

config :freegeoip, auth_user: "your_username"
config :freegeoip, auth_password: "your_password"
```


## Installation

You can install this package like any other HEX packages:

  1. Add freegeoip to your list of dependencies in `mix.exs`:

    ```ex
    def deps do
      [{:freegeoip, "~> 0.0.3"}]
    end
    ```

  2. Ensure freegeoip is started before your application:

    ```ex
    def application do
      [applications: [:freegeoip]]
    end
    ```

# Credits

[freegeoip.net](http://freegeoip.net) is
community funded, therefore consider [donating](http://freegeoip.net) if you
use and like it. 

