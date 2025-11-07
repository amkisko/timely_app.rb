require "spec_helper"

# Test Response through Client since it's a private constant
RSpec.describe "TimelyApp::Response" do
  include_context "TimelyApp::Client"

  describe ".parse" do
    it "returns :no_content for 204 responses" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/events/#{id}").with(auth_header).to_return(status: 204)

      result = client.delete_event(id)
      expect(result).to eq(:no_content)
    end

    it "parses JSON response" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events/#{id}").with(auth_header).to_return(json_response)

      result = client.get("/1.1/#{account_id}/events/#{id}")
      expect(result).to be_instance_of(TimelyApp::Record)
    end

    it "parses JSON response with Link header" do
      link_header = '<https://api.timelyapp.com/1.1/account/events?page=2>; rel="next"'
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 200,
        body: "{}",
        headers: {"Content-Type" => "application/json", "Link" => link_header}
      )

      result = client.get("/1.1/#{account_id}/events")
      expect(result.link).to be_instance_of(TimelyApp::Record)
      expect(result.link[:next]).to eq("/1.1/account/events?page=2")
    end

    it "returns body for non-JSON response" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 200,
        body: "plain text",
        headers: {"Content-Type" => "text/plain"}
      )

      result = client.get("/1.1/#{account_id}/events")
      expect(result).to eq("plain text")
    end
  end

  describe ".error" do
    it "creates error with message from JSON response" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 400,
        body: '{"errors": {"message": "Invalid request"}}',
        headers: {"Content-Type" => "application/json"}
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ClientError) do |error|
        expect(error.message).to eq("Invalid request")
      end
    end

    it "creates error with error_description from JSON response" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 401,
        body: '{"error_description": "Invalid token"}',
        headers: {"Content-Type" => "application/json"}
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::UnauthorizedError) do |error|
        expect(error.message).to eq("Invalid token")
      end
    end

    it "creates error without message for non-JSON response" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 400,
        body: "plain text",
        headers: {"Content-Type" => "text/plain"}
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ClientError) do |error|
        # When message is nil, StandardError uses the class name
        expect(error.message).to eq("TimelyApp::ClientError")
      end
    end

    it "creates UnauthorizedError for 401" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 401,
        body: "{}",
        headers: {"Content-Type" => "application/json"}
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::UnauthorizedError)
    end

    it "creates ForbiddenError for 403" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 403,
        body: "{}",
        headers: {"Content-Type" => "application/json"}
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ForbiddenError)
    end

    it "creates NotFoundError for 404" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events/#{id}").with(auth_header).to_return(
        status: 404,
        body: "{}",
        headers: {"Content-Type" => "application/json"}
      )

      expect {
        client.get("/1.1/#{account_id}/events/#{id}")
      }.to raise_error(TimelyApp::NotFoundError)
    end

    it "creates ClientError for other 4xx errors" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 422,
        body: "{}",
        headers: {"Content-Type" => "application/json"}
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ClientError)
    end

    it "creates ServerError for 5xx errors" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 500,
        body: "{}",
        headers: {"Content-Type" => "application/json"}
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ServerError)
    end

    it "creates generic Error for unknown status codes" do
      # Create a custom response class that doesn't match any known HTTP error types
      custom_response = Object.new
      def custom_response.content_type
        "application/json"
      end

      def custom_response.body
        "{}"
      end

      # Access Response through const_get since it's private
      response_module = TimelyApp.send(:const_get, :Response)
      error = response_module.error(custom_response)
      expect(error).to be_instance_of(TimelyApp::Error)
    end
  end
end
