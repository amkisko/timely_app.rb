require "spec_helper"

RSpec.describe "TimelyApp::Client clients methods" do
  include_context "TimelyApp::Client"

  describe "#create_client" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/clients").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_client(name: "test-client")).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_clients" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/clients").with(auth_header).to_return(json_array_response)

      expect(client.get_clients).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/clients?limit=10")

      client.get_clients(limit: 10)
    end
  end

  describe "#get_client" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/clients/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_client(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_client" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/clients/#{id}").with(json_request).to_return(json_response)

      expect(client.update_client(id, name: "updated-client")).to be_instance_of(TimelyApp::Record)
    end
  end
end
