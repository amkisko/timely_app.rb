require 'spec_helper'

RSpec.describe 'TimelyApp::Client auth methods' do
  include_context 'TimelyApp::Client'

  describe '#get_oauth_authorize_url' do
    let(:redirect_uri) { 'https://example.com' }
    let(:client_id) { 'client-id-xxx' }
    let(:url) {
      "#{base_url}/1.1/oauth/authorize?response_type=code&redirect_uri=https%3A%2F%2Fexample.com&client_id=client-id-xxx"
    }
    it 'returns full url' do
      expect(client.get_oauth_authorize_url(redirect_uri: redirect_uri, client_id: client_id)).to eq(url)
    end
  end

  describe '#post_oauth_token' do
    it 'returns a record' do
      expect_request(:post, "#{base_url}/1.1/oauth/token").with(json_request).to_return(json_response.merge(status: 200))

      expect(client.post_oauth_token(client_id: "client-id-xxx", client_secret: "client-secret-xxx", code: "code-xxx", redirect_uri: "redirect-uri-xxx")).to be_instance_of(TimelyApp::Record)
    end
  end
end
