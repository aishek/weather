# frozen_string_literal: true

require 'weather/version'
require 'weather/service'
require 'weather/service/metaweather'
require 'weather/service/openweathermap'

#
# Get weather by service and city
#
module Weather
  class Error < StandardError; end

  def self.get_details(service: nil, city: nil)
    service_provider = Weather::Service.create(service)
    details = service_provider.get_details(city)

    "Температура воздуха — #{details[:temperature]} градуса цельсия, ветер #{details[:wind][:speed]} м/с, давление — #{details[:air_pressure]} мм ртутного столба." # rubocop:disable LineLength
  end
end
