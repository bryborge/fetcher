# frozen_string_literal: true

require_relative '../../config/environment'
require_relative '../spec_helper'

describe 'The Base API controller' do
  it 'returns a json response' do
    # Arrange, Act
    get '/'
    # Assert
    expect(last_response.headers['Content-Type']).to include('application/json')
  end

  it 'shows a welcome message in json' do
    # Arrange, Act
    get '/'
    json_response = JSON.parse(last_response.body)
    # Assert
    expect(json_response['message']).to eq('Welcome to the Fetcher API')
  end
end
