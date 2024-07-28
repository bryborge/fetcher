# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'FetchRequestsController', type: :request do
  let(:valid_params) { { url: 'http://example.com', requested_by: 'user@example.com' } }
  let(:invalid_params) { { url: '', requested_by: '' } }

  describe 'POST /fetch_requests' do
    context 'with valid parameters' do
      it 'creates a new fetch request and enqueues a job' do
        allow(FetchHtmlJob).to receive(:perform_async)

        post '/fetch_requests', valid_params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(201)
        json_response = JSON.parse(last_response.body)
        expect(json_response['status']).to eq('pending')
        expect(FetchHtmlJob).to have_received(:perform_async).once
        expect(FetchRequest.find(json_response['id'])).not_to be_nil
      end
    end

    context 'with invalid parameters' do
      it 'does not create a fetch request and returns errors' do
        post '/fetch_requests', invalid_params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(422)
        json_response = JSON.parse(last_response.body)
        expect(json_response['errors']).to include("Url can't be blank", "Requested by can't be blank")
      end
    end
  end
end
