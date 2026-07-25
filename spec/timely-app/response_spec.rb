require "spec_helper"

# Test Response through Client since it's a private constant
RSpec.describe "TimelyApp::Response" do
  include_context "with TimelyApp::Client"

  let(:json_headers) { {TimelyApp::TestLiterals::CONTENT_TYPE_HEADER => TimelyApp::TestLiterals::APPLICATION_JSON} }

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

    it "parses JSON response with Link header", :aggregate_failures do
      link_header = '<https://api.timelyapp.com/1.1/account/events?page=2>; rel="next"'
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 200,
        body: "{}",
        headers: json_headers.merge("Link" => link_header)
      )

      result = client.get("/1.1/#{account_id}/events")
      expect(result.link).to be_instance_of(TimelyApp::Record)
      expect(result.link[:next]).to eq("/1.1/account/events?page=2")
    end

    it "returns body for non-JSON response" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 200,
        body: TimelyApp::TestLiterals::PLAIN_TEXT_BODY,
        headers: {TimelyApp::TestLiterals::CONTENT_TYPE_HEADER => "text/plain"}
      )

      result = client.get("/1.1/#{account_id}/events")
      expect(result).to eq(TimelyApp::TestLiterals::PLAIN_TEXT_BODY)
    end
  end

  describe ".error" do
    it "creates error with message from JSON response", :aggregate_failures do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 400,
        body: '{"errors": {"message": "Invalid request"}}',
        headers: json_headers
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ClientError) do |error|
        expect(error.message).to eq("Invalid request")
      end
    end

    it "creates error with error_description from JSON response", :aggregate_failures do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 401,
        body: '{"error_description": "Invalid token"}',
        headers: json_headers
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::UnauthorizedError) do |error|
        expect(error.message).to eq("Invalid token")
      end
    end

    it "creates error without message for non-JSON response", :aggregate_failures do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 400,
        body: TimelyApp::TestLiterals::PLAIN_TEXT_BODY,
        headers: {TimelyApp::TestLiterals::CONTENT_TYPE_HEADER => "text/plain"}
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
        headers: json_headers
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::UnauthorizedError)
    end

    it "creates ForbiddenError for 403" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 403,
        body: "{}",
        headers: json_headers
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ForbiddenError)
    end

    it "creates NotFoundError for 404" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events/#{id}").with(auth_header).to_return(
        status: 404,
        body: "{}",
        headers: json_headers
      )

      expect {
        client.get("/1.1/#{account_id}/events/#{id}")
      }.to raise_error(TimelyApp::NotFoundError)
    end

    it "creates ClientError for other 4xx errors" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 422,
        body: "{}",
        headers: json_headers
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ClientError)
    end

    it "creates ServerError for 5xx errors" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(
        status: 500,
        body: "{}",
        headers: json_headers
      )

      expect {
        client.get("/1.1/#{account_id}/events")
      }.to raise_error(TimelyApp::ServerError)
    end

    it "creates generic Error for unknown status codes" do
      # Create a custom response class that doesn't match any known HTTP error types
      custom_response = Object.new
      def custom_response.content_type
        TimelyApp::TestLiterals::APPLICATION_JSON
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
