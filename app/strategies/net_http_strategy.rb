# frozen_string_literal: true

require 'net/http'
require_relative './base_strategy'

# Concrete Strategy: NetHttp
#   - https://github.com/ruby/net-http
class NetHttpStrategy < BaseStrategy
  # Fetches HTML from a given URL.
  #
  # @param [String] url The URL to fetch.
  # @return [Hash] The response hash containing the status code, body, and error message.
  def fetch(url)
    uri      = URI(url)
    response = Net::HTTP.get_response(uri)

    { code: response.code.to_i, body: response.body, error: response.message }
  rescue StandardError => e
    { code: 500, body: nil, error: e.message }
  end
end
