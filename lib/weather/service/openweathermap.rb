# frozen_string_literal: true

require 'json'
require 'weather/http_client'

#
# openweathermap service for weather
#
class Weather::Service::Openweathermap
  class NoApiKeyError < ArgumentError; end

  def initialize(http_client: Weather::HttpClient, api_key: nil, **_rest)
    @http_client = http_client
    @api_key = api_key
    raise NoApiKeyError, 'Openweathermap service need API key' unless @api_key

    freeze
  end

  def get_details(city)
    weather = get_weather(city)

    {
      temperature: weather['main']['temp'],
      wind: {
        speed: weather['wind']['speed'],
        direction: weather['wind']['deg']
      },
      air_pressure: weather['main']['pressure']
    }
  end

  private

  def get_weather(city)
    uri = URI.parse("http://api.openweathermap.org/data/2.5/weather?q=#{city}&units=metric&appid=#{@api_key}") # rubocop:disable LineLength
    response = @http_client.get(uri)
    JSON.parse(response)
  end
end
