RSpec.shared_context 'TimelyApp::Client' do
  let(:token) { 'token-xxx' }
  let(:account_id) { 'account-id-xxx' }
  let(:id) { 123 }
  let(:ids) { %w[123 456 789] }
  let(:base_url) { 'https://api.timelyapp.com' }
  let(:auth_header) { {headers: {'Authorization' => "Bearer #{token}"}} }
  let(:json_request) { {headers: {'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json'}, body: /\A{.+}\z/} }
  let(:json_response_headers) { {'Content-Type' => 'application/json;charset=utf-8'} }
  let(:json_response) { {headers: json_response_headers, body: '{}'} }
  let(:json_array_response) { {headers: json_response_headers, body: '[]'} }
  let(:client) { TimelyApp::Client.new(access_token: token, account_id: account_id) }

  before do
    WebMock.reset!

    @request = nil
  end

  after do
    expect(@request).to have_been_made.times(1) if @request
  end

  def expect_request(*args)
    @request = stub_request(*args)
  end
end
