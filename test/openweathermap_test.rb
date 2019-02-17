# frozen_string_literal: true

require 'test_helper'

class WeatherTest < Minitest::Test
  def test_return_correct_weather_from_openweathermap
    http_client = Module.new do
      def self.get(url)
        case url.to_s
        when 'http://api.openweathermap.org/data/2.5/weather?q=tver&units=metric&appid=key'
          '{"coord":{"lon":13.39,"lat":52.52},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":23,"pressure":746,"humidity":47,"temp_min":13,"temp_max":13},"visibility":10000,"wind":{"speed":2,"deg":180},"clouds":{"all":0},"dt":1550415000,"sys":{"type":1,"id":1275,"message":0.0038,"country":"DE","sunrise":1550384284,"sunset":1550420614},"id":2950159,"name":"Tver","cod":200}' # rubocop:disable LineLength
        else raise NotImplementedError
        end
      end
    end

    assert do
      Weather.new(service: 'openweathermap', api_key: 'key', http_client: http_client).get_details(city: 'tver') == { # rubocop:disable LineLength
        temperature: 23,
        wind: {
          speed: 2,
          direction: 180
        },
        air_pressure: 746
      }
    end
  end

  def test_raise_on_no_api_key_openweathermap
    assert_raises Weather::Service::Openweathermap::NoApiKeyError do
      Weather.new(service: 'openweathermap').get_details(city: 'tver')
    end
  end
end
