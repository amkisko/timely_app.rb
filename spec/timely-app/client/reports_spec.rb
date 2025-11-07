require "spec_helper"

RSpec.describe "TimelyApp::Client reports methods" do
  include_context "TimelyApp::Client"

  describe "#get_reports" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/reports").with(
        headers: {"Authorization" => "Bearer #{token}", "Content-Type" => "application/json"},
        body: "{}"
      ).to_return(json_response)

      expect(client.get_reports).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_filter_reports" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/reports/filter").with(
        headers: {"Authorization" => "Bearer #{token}", "Content-Type" => "application/json"},
        body: "{}"
      ).to_return(json_response)

      expect(client.get_filter_reports).to be_instance_of(TimelyApp::Record)
    end
  end
end
