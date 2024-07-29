# frozen_string_literal: true

require 'spec_helper'
require 'sidekiq/testing'
require 'aws-sdk-s3'
require_relative '../../app/jobs/fetch_html_job'
require_relative '../../app/models/fetch_request'
require_relative '../../app/services/html_fetcher'

RSpec.describe FetchHtmlJob, type: :job do
  let(:fetch_request) { FetchRequest.create(url: 'http://example.com', requested_by: 'tester', status: 'pending') }
  let(:html_body) { '<html><body>Example</body></html>' }
  let(:success_result) { { code: 200, body: html_body } }
  let(:failure_result) { { code: 404, error: 'Not Found' } }
  let(:mock_s3_object) { instance_double(Aws::S3::Object) }

  before do
    allow(FetchRequest).to receive(:find).and_return(fetch_request)

    # Mock the S3 interactions
    allow(Aws::S3::Resource).to receive(:new).and_return(double(bucket: double(object: mock_s3_object)))
    allow(mock_s3_object).to receive(:put)
    allow(mock_s3_object).to receive(:public_url).and_return('http://example.com/html_documents/1.html')
  end

  describe '#perform' do
    context 'when the fetch is successful' do
      before do
        allow_any_instance_of(HtmlFetcher).to receive(:fetch).and_return(success_result)
      end

      it 'fetches the HTML and stores it in S3' do
        described_class.new.perform(fetch_request.id)

        expect(mock_s3_object).to have_received(:put).with(body: html_body)
        expect(fetch_request.reload.status).to eq('successful')
        expect(fetch_request.storage_url).to eq('http://example.com/html_documents/1.html')
      end
    end
  end

  context 'when the fetch fails' do
    before do
      allow_any_instance_of(HtmlFetcher).to receive(:fetch).and_return(failure_result)
    end

    it 'logs the error and updates the status to failed' do
      expect(LOGGER).to receive(:error).with("Fetch failed for FetchRequest ID #{fetch_request.id}: Not Found")

      described_class.new.perform(fetch_request.id)

      expect(mock_s3_object).not_to have_received(:put)
      expect(fetch_request.reload.status).to eq('failed')
    end
  end
end
