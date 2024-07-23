require 'net/http'
require_relative './base_strategy'

class NetHttpStrategy < BaseStrategy
  def fetch(url)
    uri      = URI(url)
    response = Net::HTTP.get_response(uri)
    
    { code: response.code.to_i, body: response.body, error: response.message }
  rescue => e
    { code: 500, body: nil, error: e.message }
  end
end
