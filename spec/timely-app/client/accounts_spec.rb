require "spec_helper"

RSpec.describe "TimelyApp::Client accounts methods" do
  include_context "TimelyApp::Client"

  describe "#get_accounts" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/accounts").with(auth_header).to_return(json_array_response)

      expect(client.get_accounts).to eq([])
    end
  end

  describe "#get_account_activities" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/activities").with(auth_header).to_return(json_array_response)

      expect(client.get_account_activities(account_id)).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/activities?limit=20")

      client.get_account_activities(account_id, limit: 20)
    end
  end

  describe "#get_account" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/accounts/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_account(id)).to be_instance_of(TimelyApp::Record)
    end
  end
end
