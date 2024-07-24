# frozen_string_literal: true

require 'aws-sdk-s3'
require 'sidekiq'
require_relative '../models/fetch_request'
require_relative '../services/html_fetcher'

# Fetch HTML Job
class FetchHtmlJob
  include Sidekiq::Job

  # Performs the html fetch job.
  #
  # @param [Integer] fetch_request_id The ID of the fetch request.
  # @param [String] strategy_name The name of the strategy to use.
  # @return [void]
  def perform(fetch_request_id, strategy_name = 'NetHttpStrategy')
    fetch_request = FetchRequest.find(fetch_request_id)
    fetch_result  = fetch_html(fetch_request, strategy_name)

    if fetch_result[:code] == 200
      store_html_in_s3(fetch_request, fetch_result[:body])
    else
      LOGGER.error("Fetch failed for FetchRequest ID #{fetch_request.id}: #{fetch_result[:error]}")
      fetch_request.update(status: 'failed')
    end
  rescue StandardError => e
    LOGGER.error("Exception occurred for FetchRequest ID #{fetch_request.id}: #{e.message}")
    fetch_request.update(status: 'failed')
  end

  private

  # Fetches HTML from a given URL using the specified strategy.
  #
  # @param [FetchRequest] fetch_request The fetch request.
  # @param [String] strategy_name The name of the strategy to use.
  # @return [Hash] The response hash containing the status code, body, and error message.
  def fetch_html(fetch_request, strategy_name)
    strategy_class = Object.const_get(strategy_name)
    HtmlFetcher.new(strategy_class.new).fetch(fetch_request.url)
  end

  # Stores the fetched HTML document in AWS S3.
  #
  # @param [FetchRequest] fetch_request The fetch request.
  # @param [String] html_body The HTML body to store.
  # @return [void]
  def store_html_in_s3(fetch_request, html_body)
    s3  = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object("html_documents/#{fetch_request.id}.html")
    obj.put(body: html_body.to_s)

    fetch_request.update(status: 'successful', storage_url: obj.public_url)
  end
end
