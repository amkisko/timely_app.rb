require "spec_helper"

RSpec.describe "TimelyApp::Client" do
  include_context "TimelyApp::Client"

  context "with a bad request error" do
    it "raises an exception" do
      response = json_response.merge(status: 422, body: %(
        {
          "errors":{
            "name":[
              "can't be blank"
            ],
            "project_users":[
              "is invalid"
            ]
          }
        }
      ))

      stub_request(:put, "#{base_url}/1.1/#{account_id}/projects/#{id}").to_return(response)

      expect { client.update_project(id, name: nil, color: nil, client_id: nil, users: nil) }.to raise_error(TimelyApp::Error) { |exception|
        expect(exception.response.body).to eq(response[:body])
        expect(exception.errors["name"]).to eq(["can't be blank"])
        expect(exception.errors["project_users"]).to eq(["is invalid"])
      }
    end
  end

  describe "with an authentication error" do
    it "raises an exception" do
      response = json_response.merge(status: 401)

      stub_request(:get, "#{base_url}/1.1/accounts").to_return(response)

      expect { client.get_accounts }.to raise_error(TimelyApp::UnauthorizedError)
    end
  end
end
