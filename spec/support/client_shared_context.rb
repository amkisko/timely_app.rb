RSpec.shared_context "with TimelyApp::Client" do
  let(:token) { "token-xxx" }
  let(:account_id) { "account-id-xxx" }
  let(:id) { 123 }
  let(:ids) { %w[123 456 789] }
  let(:base_url) { "https://api.timelyapp.com" }
  let(:auth_header) { {headers: {"Authorization" => "Bearer #{token}"}} }
  let(:json_request) { {headers: {"Authorization" => "Bearer #{token}", "Content-Type" => "application/json"}, body: /\A{.+}\z/} }
  let(:json_response_headers) { {"Content-Type" => "application/json;charset=utf-8"} }
  let(:json_response) { {headers: json_response_headers, body: "{}"} }
  let(:json_array_response) { {headers: json_response_headers, body: "[]"} }
  let(:client) { TimelyApp::Client.new(access_token: token, account_id: account_id) }
  let(:request_tracker) { {stub: nil} }

  before do
    WebMock.reset!
    request_tracker[:stub] = nil
  end

  after do
    WebMock.assert_requested(request_tracker[:stub], times: 1) if request_tracker[:stub]
  end

  def expect_request(*args)
    request_tracker[:stub] = stub_request(*args)
  end
end
