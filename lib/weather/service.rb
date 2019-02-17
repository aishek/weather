# frozen_string_literal: true

#
# Factory for weather service
#
module Weather::Service
  class UnknownServiceError < RuntimeError; end

  class << self
    def create(name, options = {})
      klass = service_klass(name)
      klass.new(options)
    end

    private

    def service_klass(name)
      const_name = "Weather::Service::#{name.capitalize}"
      Object.const_get(const_name)
    rescue StandardError
      raise UnknownServiceError, "Service #{name} is unknown"
    end
  end
end
