# frozen_string_literal: true

require 'faraday'
require_relative './base_strategy'

class FaradayStrategy < BaseStrategy
  def fetch(url)
    response = Faraday.get(url)

    {
      code: response.status,
      body: response.body,
      error: response.reason_phrase
    }
  end
end
