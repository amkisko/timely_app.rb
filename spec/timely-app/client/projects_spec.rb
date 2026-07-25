require "spec_helper"

RSpec.describe TimelyApp::Client do
  include_context "with TimelyApp::Client"

  describe "#create_project" do
    it TimelyApp::TestLiterals::RETURNS_A_RECORD do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/projects").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_project(name: "test-project", color: "ff0000", client_id: id, users: [])).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_projects" do
    it TimelyApp::TestLiterals::RETURNS_AN_ARRAY do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/projects").with(auth_header).to_return(json_array_response)

      expect(client.get_projects).to eq([])
    end

    it TimelyApp::TestLiterals::ENCODES_PARAMS do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/projects?limit=10")

      client.get_projects(limit: 10)
    end
  end

  describe "#delete_project" do
    it "returns :no_content" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/projects/#{id}").with(auth_header).to_return(status: 204)

      expect(client.delete_project(id)).to eq(:no_content)
    end
  end

  describe "#get_project" do
    it TimelyApp::TestLiterals::RETURNS_A_RECORD do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/projects/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_project(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_project" do
    it TimelyApp::TestLiterals::RETURNS_A_RECORD do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/projects/#{id}").with(json_request).to_return(json_response)

      expect(client.update_project(id, name: "updated-project", color: "00ff00", client_id: id, users: [])).to be_instance_of(TimelyApp::Record)
    end
  end
end
