# frozen_string_literal: true

require 'faraday'
require_relative './base_strategy'

# Concrete Strategy: Faraday
#   - https://github.com/lostisland/faraday
class FaradayStrategy < BaseStrategy
  # Fetches HTML from a given URL.
  #
  # @param [String] url The URL to fetch.
  # @return [Hash] The response hash containing the status code, body, and error message.
  def fetch(url)
    response = Faraday.get(url)

    { code: response.status, body: response.body, error: response.reason_phrase }
  rescue StandardError => e
    { code: 500, body: nil, error: e.message }
  end
end
