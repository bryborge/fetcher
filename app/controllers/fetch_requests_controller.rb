# frozen_string_literal: true

require_relative '../jobs/fetch_html_job'

class FetchRequestsController < BaseApiController
  post '/fetch_requests' do
    params        = JSON.parse(request.body.read)
    fetch_request = FetchRequest.new(
      url: params['url'],
      requested_by: params['requested_by'],
      status: 'pending'
    )

    if fetch_request.save
      # Kick off the job (defaults to NetHttpStrategy)
      FetchHtmlJob.perform_async(fetch_request.id)
      status 201
      { id: fetch_request.id, status: fetch_request.status }.to_json
    else
      status 422
      { errors: fetch_request.errors.full_messages }.to_json
    end
  end
end
