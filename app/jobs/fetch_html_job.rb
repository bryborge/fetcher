require 'aws-sdk-s3'
require 'sidekiq'
require_relative '../models/fetch_request'
require_relative '../services/html_fetcher'

class FetchHtmlJob
  include Sidekiq::Job

  def perform(fetch_request_id, strategy_name = 'HttpartyStrategy')
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
      # TODO: log error
      fetch_request.update(status: 'failed') #, error_message: response.message)
    end
  rescue => e
    # TODO: log error
    fetch_request.update(status: 'failed') #, error_message: e.message)
  end
end
