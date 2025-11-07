require "spec_helper"

RSpec.describe "TimelyApp::Client users methods" do
  include_context "TimelyApp::Client"

  describe "#create_user" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/users").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_user(name: "Test User", email: "test@example.com", role_id: id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#delete_user" do
    it "returns :no_content" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/users/#{id}").with(auth_header).to_return(status: 204)

      expect(client.delete_user(id)).to eq(:no_content)
    end
  end

  describe "#get_users" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users").with(auth_header).to_return(json_array_response)

      expect(client.get_users).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users?limit=10")

      client.get_users(limit: 10)
    end
  end

  describe "#get_user" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_user(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_current_user" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/current").with(auth_header).to_return(json_response)

      expect(client.get_current_user).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_user" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/users/#{id}").with(json_request).to_return(json_response)

      expect(client.update_user(id, name: "Updated User", email: "updated@example.com", role_id: id)).to be_instance_of(TimelyApp::Record)
    end
  end
end
