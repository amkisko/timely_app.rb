require "spec_helper"

RSpec.describe "TimelyApp::Client options" do
  include_context "TimelyApp::Client"

  describe "user_agent option" do
    let(:user_agent) { "custom.timelyapp.client" }

    it "specifies the user agent header to use" do
      client = TimelyApp::Client.new(access_token: token, user_agent: user_agent, account_id: account_id)

      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(headers: {"User-Agent" => user_agent})

      client.get_events
    end
  end

  describe "access_token option" do
    let(:access_token) { "oauth2-access-token" }

    it "specifies the access token to use" do
      client = TimelyApp::Client.new(access_token: access_token, account_id: account_id)

      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(headers: {"Authorization" => "Bearer oauth2-access-token"})

      client.get_events
    end
  end
end
