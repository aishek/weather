# frozen_string_literal: true

require 'test_helper'
require 'weather/service/test'

class WeatherTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Weather::VERSION
  end

  def test_return_weather_text
    assert { Weather.get_details(service: 'test', city: 'Тверь') == 'Температура воздуха — 23 градуса цельсия, ветер 2 м/с, давление — 746 мм ртутного столба.' } # rubocop:disable LineLength
  end
end
