require "spec_helper"

RSpec.describe "TimelyApp::Client teams methods" do
  include_context "TimelyApp::Client"

  describe "#create_team" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/teams").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_team(name: "test-team", users: [])).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#delete_team" do
    it "returns :no_content" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/teams/#{id}").with(auth_header).to_return(status: 204)

      expect(client.delete_team(id)).to eq(:no_content)
    end
  end

  describe "#get_teams" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/teams").with(auth_header).to_return(json_array_response)

      expect(client.get_teams).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/teams?limit=10")

      client.get_teams(limit: 10)
    end
  end

  describe "#get_team" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/teams/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_team(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_team" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/teams/#{id}").with(json_request).to_return(json_response)

      expect(client.update_team(id, name: "updated-team", users: [])).to be_instance_of(TimelyApp::Record)
    end
  end
end
