# frozen_string_literal: true

require 'httparty'
require_relative './base_strategy'

# Concrete Strategy: Httparty
#   - https://github.com/jnunemaker/httparty
class HttpartyStrategy < BaseStrategy
  # Fetches HTML from a given URL.
  #
  # @param [String] url The URL to fetch.
  # @return [Hash] The response hash containing the status code, body, and error message.
  def fetch(url)
    response = HTTParty.get(url)

    { code: response.code, body: response, error: response.message }
  rescue StandardError => e
    { code: 500, body: nil, error: e.message }
  end
end
