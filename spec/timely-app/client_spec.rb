require "spec_helper"

class TimelyTestJob
  def get_events
    client.get_events(day: "2023-01-01", page: 1, per_page: 50)
  end

  def get_projects
    client.get_projects
  end

  def client
    @client ||= TimelyApp::Client.new(
      account_id: "test_account_id",
      access_token: "test_access_token"
    )
  end
end

RSpec.describe TimelyApp::Client do
  describe "#get_events" do
    before do
      stub_request(:get, "https://api.timelyapp.com/1.1/test_account_id/events?day=2023-01-01&page=1&per_page=50")
        .with(
          headers: {
            "Authorization" => "Bearer test_access_token"
          }
        ).to_return(status: 200, body: response.to_json, headers: {
          "Content-Type" => "application/json;charset=utf-8"
        })
    end
    let(:response) {
      [
        {
          id: 71,
          uid: "e2c420d928d4bf8ce0ff2ec19b371514",
          user: {
            id: 143,
            email: "marijaapxgnfod@timelyapp.com",
            name: "Marija Petrovic",
            avatar: {
              large_retina: "https://www.gravatar.com/avatar/18bb21bcbf431e4452c17ea864ae310e?d=http%3A%2F%2Fapp.timelyapp.local%2Fassets%2Fthumbs%2Fuser_large_retina-c403e04ad44c7d8b8c7904dc7e7c1893101f3672565370034edbe3dee9985509.jpg&s=200",
              large: "https://www.gravatar.com/avatar/18bb21bcbf431e4452c17ea864ae310e?d=http%3A%2F%2Fapp.timelyapp.local%2Fassets%2Fthumbs%2Fuser_large-c403e04ad44c7d8b8c7904dc7e7c1893101f3672565370034edbe3dee9985509.jpg&s=",
              medium_retina: "https://www.gravatar.com/avatar/18bb21bcbf431e4452c17ea864ae310e?d=http%3A%2F%2Fapp.timelyapp.local%2Fassets%2Fthumbs%2Fuser_medium_retina-459a8b7582a7417f4b47a0064f692ffcd161fb11eda9dcc359f1b5e63fe51235.jpg&s=50",
              medium: "https://www.gravatar.com/avatar/18bb21bcbf431e4452c17ea864ae310e?d=http%3A%2F%2Fapp.timelyapp.local%2Fassets%2Fthumbs%2Fuser_medium-459a8b7582a7417f4b47a0064f692ffcd161fb11eda9dcc359f1b5e63fe51235.jpg&s=",
              timeline: "https://www.gravatar.com/avatar/18bb21bcbf431e4452c17ea864ae310e?d=http%3A%2F%2Fapp.timelyapp.local%2Fassets%2Fthumbs%2Fuser_timeline-e61ac46443487bd24fbaecab08cfacf5d0835b371cbe97a33b9e738744ef8334.jpg&s="
            },
            updated_at: "2023-07-13T14:25:10+02:00"
          },
          project: {
            id: 45,
            active: true,
            account_id: 67,
            name: "Timely",
            color: "67a3bc",
            rate_type: "project",
            billable: true,
            created_at: 1689251110,
            updated_at: 1689251110,
            external_id: nil,
            budget_scope: nil,
            client: {
              id: 46,
              name: "Dolorem accusamus consequuntur nihil.",
              active: true,
              external_id: nil,
              updated_at: "2023-07-13T14:25:10+02:00"
            },
            required_notes: false,
            required_labels: false,
            budget_expired_on: nil,
            has_recurrence: false,
            enable_labels: "all",
            default_labels: false,
            currency: {
              id: "usd",
              name: "United States Dollar",
              iso_code: "USD",
              symbol: "$",
              symbol_first: true
            },
            budget: 0,
            budget_type: "",
            budget_calculation: "completed",
            hour_rate: 50.0,
            hour_rate_in_cents: 5000.0,
            budget_progress: 0.0,
            budget_percent: 0.0,
            invoice_by_budget: false,
            labels: [],
            label_ids: [],
            required_label_ids: [],
            default_label_ids: [],
            created_from: "Web"
          },
          duration: {
            hours: 3,
            minutes: 30,
            seconds: 0,
            formatted: "03:30",
            total_hours: 3.5,
            total_seconds: 12600,
            total_minutes: 210
          },
          estimated_duration: {
            hours: 4,
            minutes: 0,
            seconds: 0,
            formatted: "04:00",
            total_hours: 4.0,
            total_seconds: 14400,
            total_minutes: 240
          },
          cost: {
            fractional: 35000,
            formatted: "$350.00",
            amount: 350.0,
            currency_code: "usd"
          },
          estimated_cost: {
            fractional: 40000,
            formatted: "$400.00",
            amount: 400.0,
            currency_code: "usd"
          },
          day: "2023-07-13",
          note: "Notes for testing with some random #hash in it.",
          sequence: 1,
          estimated: false,
          timer_state: "default",
          timer_started_on: 0,
          timer_stopped_on: 0,
          label_ids: [],
          user_ids: [],
          updated_at: 1689251110,
          created_at: 1689251110,
          created_from: "Web",
          updated_from: "Web",
          billed: false,
          billable: true,
          to: "2023-07-13T17:55:10+02:00",
          from: "2023-07-13T14:25:10+02:00",
          deleted: false,
          hour_rate: 100.0,
          hour_rate_in_cents: 10000,
          creator_id: nil,
          updater_id: nil,
          external_id: nil,
          entry_ids: [],
          suggestion_id: nil,
          draft: false,
          manage: true,
          forecast_id: nil,
          billed_at: nil,
          locked_reason: nil,
          locked: false,
          invoice_id: nil,
          timestamps: []
        }
      ]
    }
    it "returns record" do
      events = TimelyTestJob.new.get_events
      expect(events.first.project.client).to be_a(TimelyApp::Record)
    end
  end

  describe "#get_projects" do
    before do
      stub_request(:get, "https://api.timelyapp.com/1.1/test_account_id/projects")
        .with(
          headers: {
            "Authorization" => "Bearer test_access_token"
          }
        ).to_return(status: 200, body: response.to_json, headers: {
          "Content-Type" => "application/json;charset=utf-8"
        })
    end
    let(:response) {
      [
        {
          id: 110,
          active: true,
          account_id: 177,
          name: "Timely",
          color: "67a3bc",
          rate_type: "project",
          billable: true,
          created_at: 1689251121,
          updated_at: 1689251121,
          external_id: nil,
          budget_scope: nil,
          client: {
            id: 129,
            name: "Aliquam magnam et distinctio.",
            active: true,
            external_id: nil,
            updated_at: "2023-07-13T14:25:21+02:00"
          },
          required_notes: false,
          required_labels: false,
          budget_expired_on: nil,
          has_recurrence: false,
          enable_labels: "all",
          default_labels: false,
          currency: {
            id: "usd",
            name: "United States Dollar",
            iso_code: "USD",
            symbol: "$",
            symbol_first: true
          },
          budget: 0,
          budget_type: "",
          budget_calculation: "completed",
          hour_rate: 50.0,
          hour_rate_in_cents: 5000.0,
          budget_progress: 0.0,
          budget_percent: 0.0,
          invoice_by_budget: false,
          users: [
            {
              user_id: 362,
              hour_rate: 100.0,
              hour_rate_in_cents: 10000.0,
              updated_at: "2023-07-13T14:25:21+02:00",
              created_at: "2023-07-13T14:25:21+02:00",
              deleted: false
            }
          ],
          labels: [],
          label_ids: [],
          required_label_ids: [],
          default_label_ids: [],
          cost: {
            fractional: 0,
            formatted: "$0.00",
            amount: 0.0,
            currency_code: "usd"
          },
          estimated_cost: {
            fractional: 0,
            formatted: "$0.00",
            amount: 0.0,
            currency_code: "usd"
          },
          duration: {
            hours: 0,
            minutes: 0,
            seconds: 0,
            formatted: "00:00",
            total_hours: 0.0,
            total_seconds: 0,
            total_minutes: 0
          },
          estimated_duration: {
            hours: 0,
            minutes: 0,
            seconds: 0,
            formatted: "00:00",
            total_hours: 0.0,
            total_seconds: 0,
            total_minutes: 0
          },
          billed_cost: {
            fractional: 0,
            formatted: "$0.00",
            amount: 0.0,
            currency_code: "usd"
          },
          billed_duration: {
            hours: 0,
            minutes: 0,
            seconds: 0,
            formatted: "00:00",
            total_hours: 0.0,
            total_seconds: 0,
            total_minutes: 0
          },
          unbilled_cost: {
            fractional: 0,
            formatted: "$0.00",
            amount: 0.0,
            currency_code: "usd"
          },
          unbilled_duration: {
            hours: 0,
            minutes: 0,
            seconds: 0,
            formatted: "00:00",
            total_hours: 0.0,
            total_seconds: 0,
            total_minutes: 0
          },
          created_from: "Web"
        }
      ]
    }
    it "returns record" do
      projects = TimelyTestJob.new.get_projects
      expect(projects.first.client).to be_a(TimelyApp::Record)
    end
  end
end
