require "spec_helper"

RSpec.describe TimelyApp::Client do
  include_context "with TimelyApp::Client"

  describe "#create_webhook" do
    it TimelyApp::TestLiterals::RETURNS_A_RECORD do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/webhooks").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_webhook(url: "https://example.com/webhook")).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#delete_webhook" do
    it "returns :no_content" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/webhooks/#{id}").with(auth_header).to_return(status: 204)

      expect(client.delete_webhook(id)).to eq(:no_content)
    end
  end

  describe "#get_webhooks" do
    it TimelyApp::TestLiterals::RETURNS_AN_ARRAY do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/webhooks").with(auth_header).to_return(json_array_response)

      expect(client.get_webhooks).to eq([])
    end

    it TimelyApp::TestLiterals::ENCODES_PARAMS do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/webhooks?limit=10")

      client.get_webhooks(limit: 10)
    end
  end

  describe "#get_webhook" do
    it TimelyApp::TestLiterals::RETURNS_A_RECORD do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/webhooks/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_webhook(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_webhook" do
    it TimelyApp::TestLiterals::RETURNS_A_RECORD do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/webhooks/#{id}").with(json_request).to_return(json_response)

      expect(client.update_webhook(id, url: "https://example.com/webhook-updated")).to be_instance_of(TimelyApp::Record)
    end
  end
end
