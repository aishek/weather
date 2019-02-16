# frozen_string_literal: true

require 'open-uri'
require 'json'

#
# https://www.metaweather.com service for weather
#
module Weather::Service::Metaweather
  class NoCityFoundError < ArgumentError; end
  class NoWeatherDetailsError < RuntimeError; end

  class << self
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
      url = "https://www.metaweather.com/api/location/search/?query=#{city}"
      open(url) do |f| # rubocop:disable Security/Open
        response = f.read
        locations = JSON.parse(response)
        raise NoCityFoundError, "City #{city} not found" if locations.empty?

        locations.first
      end
    end

    def get_location_weather(location)
      url = "https://www.metaweather.com/api/location/#{location['woeid']}/"
      open(url) do |f| # rubocop:disable Security/Open
        response = f.read
        response_data = JSON.parse(response)
        if response_data['consolidated_weather'].empty?
          raise NoWeatherDetailsError, "No weather details for #{location['title']}"
        end

        response_data['consolidated_weather'].first
      end
    end
  end
end
