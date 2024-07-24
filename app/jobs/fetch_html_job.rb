# frozen_string_literal: true

require 'aws-sdk-s3'
require 'sidekiq'
require_relative '../models/fetch_request'
require_relative '../services/html_fetcher'

# Fetch HTML Job
#
# Fetches HTML from a given URL and stores it in AWS S3.
class FetchHtmlJob
  include Sidekiq::Job

  # Performs the html fetch job.
  #
  # @param [Integer] fetch_request_id The ID of the fetch request.
  # @param [String] strategy_name The name of the strategy to use.
  # @return [void]
  def perform(fetch_request_id, strategy_name = 'NetHttpStrategy')
    fetch_request  = FetchRequest.find(fetch_request_id)
    strategy_class = Object.const_get(strategy_name)
    fetcher        = HtmlFetcher.new(strategy_class.new)

    result = fetcher.fetch(fetch_request.url)

    if result[:code] == 200
      s3  = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
      obj = s3.bucket(ENV['S3_BUCKET_NAME']).object("html_documents/#{fetch_request.id}.html")
      obj.put(body: result[:body].to_s)

      fetch_request.update(status: 'successful', storage_url: obj.public_url)
    else
      LOGGER.error("Fetch failed for FetchRequest ID #{fetch_request.id}: #{result[:error]}")
      fetch_request.update(status: 'failed')
    end
  rescue StandardError => e
    LOGGER.error("Exception occurred for FetchRequest ID #{fetch_request.id}: #{e.message}")
    fetch_request.update(status: 'failed')
  end
end
