# frozen_string_literal: true

require 'httparty'

# A simple HTTParty wrapper.
#
# Example:
#   user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
#   url        = 'https://www.scrapingcourse.com/ecommerce/page/1/'
#   fetcher    = Fetcher.new(user_agent)
#   response   = fetcher.get(url)
class Fetcher
  include HTTParty

  attr_accessor :user_agent

  # Initializes a new Fetcher object.
  #
  # @param [String] user_agent The user agent to use.
  def initialize(user_agent = '')
    @user_agent = user_agent
  end

  # Makes an HTTP GET request to the specified URL with optional parameters.
  #
  # @param [String] url The URL to send the GET request to.
  # @param [Hash] options The options to customize the request (default: {}).
  # @return [HTTParty::Response] The response object from the GET request.
  def get(url, options = {})
    options[:headers] ||= {}
    options[:headers]['User-Agent'] = @user_agent
    self.class.get(url, options)
  end
end
