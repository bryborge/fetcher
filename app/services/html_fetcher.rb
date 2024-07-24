# frozen_string_literal: true

# HTML Fetcher Service
class HtmlFetcher
  # Initializes the HTML fetcher service.
  #
  # @param [BaseStrategy] strategy The strategy to use for fetching HTML.
  # @return [void]
  def initialize(strategy)
    @strategy = strategy
  end

  # Fetches HTML from a given URL.
  #
  # @param [String] url The URL to fetch.
  # @return [Hash] The response hash containing the status code, body, and error message.
  def fetch(url)
    @strategy.fetch(url)
  end
end
