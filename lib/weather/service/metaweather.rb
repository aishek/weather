# frozen_string_literal: true

require 'json'
require 'weather/http_client'

#
# https://www.metaweather.com service for weather
#
class Weather::Service::Metaweather
  class NoCityFoundError < ArgumentError; end
  class NoWeatherDetailsError < RuntimeError; end

  def initialize(http_client: Weather::HttpClient, **_rest)
    @http_client = http_client

    freeze
  end

  def get_details(city)
    location = get_location(city)
    weather = get_location_weather(location)

    {
      temperature: weather['the_temp'],
      wind: {
        speed: weather['wind_speed'],
        direction: weather['wind_direction']
      },
      air_pressure: weather['air_pressure']
    }
  end

  private

  def get_location(city)
    uri = URI.parse("https://www.metaweather.com/api/location/search/?query=#{city}")

    response = @http_client.get(uri)
    locations = JSON.parse(response)
    raise NoCityFoundError, "City #{city} not found" if locations.empty?

    locations.first
  end

  def get_location_weather(location)
    uri = URI.parse("https://www.metaweather.com/api/location/#{location['woeid']}/")

    response = @http_client.get(uri)
    response_data = JSON.parse(response)
    if response_data['consolidated_weather'].nil? || response_data['consolidated_weather'].empty?
      raise NoWeatherDetailsError, "No weather details for #{location['title']}"
    end

    response_data['consolidated_weather'].first
  end
end
