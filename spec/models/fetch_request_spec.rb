# frozen_string_literal: true

require 'spec_helper'
require 'active_record'
require_relative '../../app/models/fetch_request'

RSpec.describe FetchRequest, type: :model do
  let(:fetch_request) { described_class.new(url: 'http://example.com', requested_by: 'user@example.com') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(fetch_request).to be_valid
    end

    it 'is not valid without a url' do
      fetch_request.url = nil
      expect(fetch_request).not_to be_valid
      expect(fetch_request.errors[:url]).to include("can't be blank")
    end

    it 'is not valid without a requested_by' do
      fetch_request.requested_by = nil
      expect(fetch_request).not_to be_valid
      expect(fetch_request.errors[:requested_by]).to include("can't be blank")
    end
  end

  describe 'attributes' do
    it 'has a url attribute' do
      expect(fetch_request).to respond_to(:url)
    end

    it 'has a requested_by attribute' do
      expect(fetch_request).to respond_to(:requested_by)
    end

    it 'has a status attribute' do
      expect(fetch_request).to respond_to(:status)
    end

    it 'has a storage_url attribute' do
      expect(fetch_request).to respond_to(:storage_url)
    end
  end
end
