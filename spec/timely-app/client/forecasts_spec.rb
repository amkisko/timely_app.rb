require "spec_helper"

RSpec.describe "TimelyApp::Client forecasts methods" do
  include_context "TimelyApp::Client"

  describe "#create_forecast" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/forecasts").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_forecast(project_id: id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#delete_forecast" do
    it "returns :no_content" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/forecasts/#{id}").with(auth_header).to_return(status: 204)

      expect(client.delete_forecast(id)).to eq(:no_content)
    end
  end

  describe "#get_forecasts" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/forecasts").with(auth_header).to_return(json_array_response)

      expect(client.get_forecasts).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/forecasts?limit=10")

      client.get_forecasts(limit: 10)
    end
  end

  describe "#update_forecast" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/forecasts/#{id}").with(json_request).to_return(json_response)

      expect(client.update_forecast(id, project_id: id, estimated_minutes: 60)).to be_instance_of(TimelyApp::Record)
    end
  end
end
