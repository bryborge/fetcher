require 'httparty'
require_relative './base_strategy'

class HttpartyStrategy < BaseStrategy
  def fetch(url)
    response = HTTParty.get(url)

    {
      code: response.code,
      body: response,
      error: response.message
    }
  end
end
