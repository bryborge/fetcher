require 'aws-sdk-s3'
require 'httparty'
require 'sidekiq'
require_relative '../models/fetch_request'

class FetchHtmlJob
  include Sidekiq::Job

  def perform(fetch_request_id)
    fetch_request = FetchRequest.find(fetch_request_id)
    
    response = HTTParty.get(fetch_request.url)

    if response.code == 200
      # TODO: load aws region and bucket name values from environment variables
      s3  = Aws::S3::Resource.new(region: 'us-west-2')
      obj = s3.bucket('deleteme-fetcher').object("html_documents/#{fetch_request.id}.html")
      obj.put(body: response.body)
      
      fetch_request.update(status: 'successful', storage_url: obj.public_url)
    else
      fetch_request.update(status: 'failed', error_message: response.message)
    end
  rescue => e
    fetch_request.update(status: 'failed', error_message: e.message)
  end
end
