require "spec_helper"

# Test LinkHeader through Response.parse since it's a private constant
RSpec.describe "TimelyApp::LinkHeader" do
  include_context "TimelyApp::Client"

  describe "parsing link headers" do
    it "parses link header with rel through Response" do
      link_header = '<https://api.timelyapp.com/1.1/account/events?page=2>; rel="next"'

      stub_request(:get, "#{base_url}/1.1/#{account_id}/events")
        .with(auth_header)
        .to_return(
          status: 200,
          body: TimelyApp::TestLiterals::JSON_ID_BODY,
          headers: {TimelyApp::TestLiterals::CONTENT_TYPE_HEADER => TimelyApp::TestLiterals::APPLICATION_JSON, "Link" => link_header}
        )

      result = client.get("/1.1/#{account_id}/events")
      expect(result.link).to be_instance_of(TimelyApp::Record)
      expect(result.link[:next]).to eq("/1.1/account/events?page=2")
    end

    it "handles empty link header" do
      stub_request(:get, "#{base_url}/1.1/#{account_id}/events")
        .with(auth_header)
        .to_return(
          status: 200,
          body: TimelyApp::TestLiterals::JSON_ID_BODY,
          headers: {TimelyApp::TestLiterals::CONTENT_TYPE_HEADER => TimelyApp::TestLiterals::APPLICATION_JSON, "Link" => ""}
        )

      result = client.get("/1.1/#{account_id}/events")
      expect(result.link).to be_instance_of(TimelyApp::Record)
      expect(result.link.to_h).to eq({})
    end

    it "handles link header without matches" do
      stub_request(:get, "#{base_url}/1.1/#{account_id}/events")
        .with(auth_header)
        .to_return(
          status: 200,
          body: TimelyApp::TestLiterals::JSON_ID_BODY,
          headers: {TimelyApp::TestLiterals::CONTENT_TYPE_HEADER => TimelyApp::TestLiterals::APPLICATION_JSON, "Link" => "no matches here"}
        )

      result = client.get("/1.1/#{account_id}/events")
      expect(result.link).to be_instance_of(TimelyApp::Record)
      expect(result.link.to_h).to eq({})
    end

    it "parses multiple link headers" do
      link_header = '<https://api.timelyapp.com/1.1/account/events?page=2>; rel="next", <https://api.timelyapp.com/1.1/account/events?page=1>; rel="prev"'

      stub_request(:get, "#{base_url}/1.1/#{account_id}/events")
        .with(auth_header)
        .to_return(
          status: 200,
          body: TimelyApp::TestLiterals::JSON_ID_BODY,
          headers: {TimelyApp::TestLiterals::CONTENT_TYPE_HEADER => TimelyApp::TestLiterals::APPLICATION_JSON, "Link" => link_header}
        )

      result = client.get("/1.1/#{account_id}/events")
      expect(result.link[:next]).to eq("/1.1/account/events?page=2")
      expect(result.link[:prev]).to eq("/1.1/account/events?page=1")
    end
  end
end
