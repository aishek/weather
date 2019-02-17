# frozen_string_literal: true

require 'open-uri'

#
# HTTP-client for weather
#
module Weather::HttpClient
  def self.get(url)
    open(url, &:read) # rubocop:disable Security/Open
  end
end
