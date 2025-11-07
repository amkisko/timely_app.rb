require "spec_helper"

RSpec.describe "TimelyApp::Client roles methods" do
  include_context "TimelyApp::Client"

  describe "#get_roles" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/roles").with(auth_header).to_return(json_array_response)

      expect(client.get_roles).to eq([])
    end
  end
end
