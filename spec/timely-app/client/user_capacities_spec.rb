require "spec_helper"

RSpec.describe "TimelyApp::Client user capacities methods" do
  include_context "TimelyApp::Client"

  describe "#get_users_capacities" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/capacities").with(auth_header).to_return(json_array_response)

      expect(client.get_users_capacities).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/capacities?limit=10")

      client.get_users_capacities(limit: 10)
    end
  end

  describe "#get_user_capacities" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/#{id}/capacities").with(auth_header).to_return(json_response)

      expect(client.get_user_capacities(user_id: id)).to be_instance_of(TimelyApp::Record)
    end
  end
end
