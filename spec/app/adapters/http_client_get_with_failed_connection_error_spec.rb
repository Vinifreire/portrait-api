# frozen_string_literal: true

describe HttpClientAdapter, '#get' do
  subject(:http_client) { described_class.get(url, headers) }

  let(:url) { 'http://localhost:3000' }
  let(:headers) { { Accept: 'application/json' } }

  let(:faraday_instance) { instance_double('Faraday::Connection') }

  before do
    allow(Faraday).to receive(:new)
      .and_return(faraday_instance)

    allow(faraday_instance).to receive(:get)
      .and_raise(Faraday::ConnectionFailed, error_message)
  end

  describe 'when the requested address does not exists' do
    let(:error_message) { 'Failed to connect to endpoint' }

    it 'raises a custom HTTPClient error message' do
      expect { http_client }.to(
        raise_error(HttpClientAdapter::ConnectionFailed, error_message)
      )
    end
  end
end
