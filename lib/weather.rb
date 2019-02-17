# frozen_string_literal: true

require 'weather/version'
require 'weather/service'
require 'weather/service/metaweather'
require 'weather/service/openweathermap'

#
# Get weather by service and city
#
class Weather
  def initialize(service: nil, **options)
    @service = Weather::Service.create(service, options)
  end

  def get_details(city: nil)
    @service.get_details(city)
  end
end
