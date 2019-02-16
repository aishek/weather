# frozen_string_literal: true

#
# test service for weather
#
module Weather::Service::Test
  class NoCityFoundError < ArgumentError; end
  class NoWeatherDetailsError < RuntimeError; end

  class << self
    def get_details(city)
      raise NotImplementedError unless city == 'Тверь'

      {
        temperature: 23,
        wind: {
          speed: 2,
          direction: 180
        },
        air_pressure: 746
      }
    end
  end
end
