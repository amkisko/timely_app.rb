require "spec_helper"

RSpec.describe "TimelyApp::Client labels methods" do
  include_context "TimelyApp::Client"

  describe "#create_label" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/labels").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_label(name: "test-label-1")).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_labels" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/labels").with(auth_header).to_return(json_array_response)

      expect(client.get_labels).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/labels?limit=10")

      client.get_labels(limit: 10)
    end
  end

  describe "#get_label" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/labels/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_label(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_label" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/labels/#{id}").with(json_request).to_return(json_response)

      expect(client.update_label(id, name: "test-label-2")).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#delete_label" do
    it "returns :no_content" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/labels/#{id}").with(auth_header).to_return(status: 204)

      expect(client.delete_label(id)).to eq(:no_content)
    end
  end

  describe "#get_child_labels" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/labels?parent_id=#{id}").with(auth_header).to_return(json_array_response)

      expect(client.get_child_labels(id)).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/labels?parent_id=#{id}")

      client.get_child_labels(id)
    end
  end
end
