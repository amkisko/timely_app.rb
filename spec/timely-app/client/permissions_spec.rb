require "spec_helper"

RSpec.describe "TimelyApp::Client permissions methods" do
  include_context "TimelyApp::Client"

  describe "#get_current_user_permissions" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/current/permissions").with(auth_header).to_return(json_response)

      expect(client.get_current_user_permissions).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_user_permissions" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/#{id}/permissions").with(auth_header).to_return(json_response)

      expect(client.get_user_permissions(user_id: id)).to be_instance_of(TimelyApp::Record)
    end
  end
end
