# frozen_string_literal: true

require 'weather/version'
require 'weather/service'
require 'weather/service/metaweather'
require 'weather/service/openweathermap'

#
# Get weather by service and city
#
class Weather
  def initialize(service)
    @service = service
  end

  def get_details(city: nil)
    @service.get_details(city)
  end
end
