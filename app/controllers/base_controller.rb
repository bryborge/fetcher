# frozen_string_literal: true

require 'sinatra/json'

# Base controller.
class BaseController < Sinatra::Base
  get '/' do
    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
    url        = 'https://www.scrapingcourse.com/ecommerce/page/1/'
    fetcher    = Fetcher.new(user_agent)
    response   = fetcher.get(url)
    json response.body
  end
end
