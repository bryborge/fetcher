# frozen_string_literal: true

class FetchRequestsController < BaseApiController
  post '/fetch_requests' do
    params        = JSON.parse(request.body.read)
    fetch_request = FetchRequest.new(
      url: params['url'],
      requested_by: params['requested_by'],
      status: 'pending'
    )

    if fetch_request.save
      # TODO: Add logic to handle queuing jobs
      # FetchHtmlJob.perform_async(fetch_request.id)
      status 201
      { id: fetch_request.id, status: fetch_request.status }.to_json
    else
      status 422
      { errors: fetch_request.errors.full_messages }.to_json
    end
  end
end

# user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
# url        = 'https://www.scrapingcourse.com/ecommerce/page/1/'
# fetcher    = Fetcher.new(user_agent)
# response   = fetcher.get(url)
# json response.body
