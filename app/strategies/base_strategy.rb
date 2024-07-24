# frozen_string_literal: true

# Base Strategy
class BaseStrategy
  # Fetches HTML from a given URL.
  #
  # @param [String] url The URL to fetch.
  # @return [Hash] The response hash containing the status code, body, and error message.
  def fetch(url)
    raise NotImplementedError, 'You must implement the fetch method'
  end
end
