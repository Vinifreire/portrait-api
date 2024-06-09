# frozen_string_literal: true
require 'rails_helper'

describe HttpClientAdapter, '#get' do
  subject(:http_client) { described_class.get(url, headers) }

  let(:url) { 'http://localhost:3000' }
  let(:headers) { { Accept: 'application/json' } }

  let(:faraday_instance) { instance_double('Faraday::Connection') }

  before do
    allow(Faraday).to receive(:new)
      .and_return(faraday_instance)

    allow(faraday_instance).to receive(:get)
  end

  it 'calls faraday' do
    expect(faraday_instance).to receive(:get)
      .with(url, {}, headers)

    http_client
  end
end
