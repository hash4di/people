require "spec_helper"

RSpec.describe "Request support for CORS headers", type: :request do
  it 'returns the response CORS headers' do
    get '/api/v3/memberships', nil, 'HTTP_ORIGIN' => '*'

    expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
    expect(response.headers['Access-Control-Allow-Methods']).to eq('GET')
  end
end
