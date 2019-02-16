# frozen_string_literal: true

require 'open-uri'
require 'json'

#
# openweathermap service for weather
#
module Weather::Service::Openweathermap
  APP_ID = '1b5ab858c97377d55541e24f9d1fd98a'
  # class NoCityFoundError < ArgumentError; end
  # class NoWeatherDetailsError < RuntimeError; end

  class << self
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
      url = "http://api.openweathermap.org/data/2.5/weather?q=#{city}&units=metric&appid=#{APP_ID}"
      open(url) do |f| # rubocop:disable Security/Open
        response = f.read
        JSON.parse(response)
      end
    end
  end
end
