require "spec_helper"

RSpec.describe "TimelyApp::Client events methods" do
  include_context "TimelyApp::Client"

  describe "#create_event" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/events").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_event(day: "2023-01-01", hours: 1, minutes: 30)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#create_project_event" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/projects/#{id}/events").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_project_event(project_id: id, day: "2023-01-01", hours: 1, minutes: 30)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#create_user_event" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/users/#{id}/events").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_user_event(user_id: id, day: "2023-01-01", hours: 1, minutes: 30)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#create_bulk_events" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/bulk/events").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.create_bulk_events(create: [])).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#delete_event" do
    it "returns :no_content" do
      expect_request(:delete, "#{base_url}/1.1/#{account_id}/events/#{id}").with(auth_header).to_return(status: 204)

      expect(client.delete_event(id)).to eq(:no_content)
    end
  end

  describe "#delete_bulk_events" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/bulk/events").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.delete_bulk_events(delete: [])).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_events" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events").with(auth_header).to_return(json_array_response)

      expect(client.get_events).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events?day=2023-01-01")

      client.get_events(day: "2023-01-01")
    end
  end

  describe "#get_project_events" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/projects/#{id}/events").with(auth_header).to_return(json_array_response)

      expect(client.get_project_events(project_id: id)).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/projects/#{id}/events?day=2023-01-01")

      client.get_project_events(project_id: id, day: "2023-01-01")
    end
  end

  describe "#get_user_events" do
    it "returns an array" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/#{id}/events").with(auth_header).to_return(json_array_response)

      expect(client.get_user_events(user_id: id)).to eq([])
    end

    it "encodes params" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/users/#{id}/events?day=2023-01-01")

      client.get_user_events(user_id: id, day: "2023-01-01")
    end
  end

  describe "#update_user_event" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/users/#{id}/events/#{id}").with(json_request).to_return(json_response)

      expect(client.update_user_event(id, user_id: id, day: "2023-01-01", hours: 2, minutes: 0)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_project_event" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/projects/#{id}/events/#{id}").with(json_request).to_return(json_response)

      expect(client.update_project_event(id, project_id: id, day: "2023-01-01", hours: 2, minutes: 0)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#get_event" do
    it "returns a record" do
      expect_request(:get, "#{base_url}/1.1/#{account_id}/events/#{id}").with(auth_header).to_return(json_response)

      expect(client.get_event(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#start_event_timer" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/events/#{id}/start").with(auth_header).to_return(json_response)

      expect(client.start_event_timer(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#stop_event_timer" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/events/#{id}/stop").with(auth_header).to_return(json_response)

      expect(client.stop_event_timer(id)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_event" do
    it "returns a record" do
      expect_request(:put, "#{base_url}/1.1/#{account_id}/events/#{id}").with(json_request).to_return(json_response)

      expect(client.update_event(id, day: "2023-01-01", hours: 2, minutes: 0)).to be_instance_of(TimelyApp::Record)
    end
  end

  describe "#update_bulk_events" do
    it "returns a record" do
      expect_request(:post, "#{base_url}/1.1/#{account_id}/bulk/events").with(json_request).to_return(json_response.merge(status: 201))

      expect(client.update_bulk_events(update: [])).to be_instance_of(TimelyApp::Record)
    end
  end
end
