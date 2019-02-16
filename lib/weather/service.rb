# frozen_string_literal: true

#
# Factory for weather service
#
module Weather::Service
  class UnknownServiceError < RuntimeError; end

  def self.create(name)
    const_name = "Weather::Service::#{name.capitalize}"
    const = Object.const_get(const_name)
    const
  rescue NameError
    raise UnknownServiceError, "Service #{name} is unknown"
  end
end
