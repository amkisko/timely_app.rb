# frozen_string_literal: true

# https://dev.timelyapp.com/#events
module TimelyApp
  class Client
    def create_event(day:, hours:, minutes:, **params)
      post("/1.1/#{account_id}/events", event: params.merge(day: day, hours: hours, minutes: minutes))
    end

    def create_project_event(project_id:, day:, hours:, minutes:, **params)
      post("/1.1/#{account_id}/projects/#{project_id}/events", event: params.merge(day: day, hours: hours, minutes: minutes))
    end

    def create_user_event(user_id:, day:, hours:, minutes:, **params)
      post("/1.1/#{account_id}/users/#{user_id}/events", event: params.merge(day: day, hours: hours, minutes: minutes))
    end

    def create_bulk_events(create)
      post("/1.1/#{account_id}/bulk/events", create: create)
    end

    def delete_event(id)
      delete("/1.1/#{account_id}/events/#{id}")
    end

    def delete_bulk_events(delete)
      post("/1.1/#{account_id}/bulk/events", delete: delete)
    end

    def get_events(**params)
      get("/1.1/#{account_id}/events", params)
    end

    def get_project_events(project_id:, **params)
      get("/1.1/#{account_id}/projects/#{project_id}/events", params)
    end

    def get_user_events(user_id:, **params)
      get("/1.1/#{account_id}/users/#{user_id}/events", params)
    end

    def update_user_event(id, user_id:, day:, hours:, minutes:, **params)
      put("/1.1/#{account_id}/users/#{user_id}/events/#{id}", event: params.merge(day: day, hours: hours, minutes: minutes))
    end

    def update_project_event(id, project_id:, day:, hours:, minutes:, **params)
      put("/1.1/#{account_id}/projects/#{project_id}/events/#{id}", event: params.merge(day: day, hours: hours, minutes: minutes))
    end

    def get_event(id)
      get("/1.1/#{account_id}/events/#{id}")
    end

    def start_event_timer(id)
      put("/1.1/#{account_id}/events/#{id}/start")
    end

    def stop_event_timer(id)
      put("/1.1/#{account_id}/events/#{id}/stop")
    end

    def update_event(id, day:, hours:, minutes:, **params)
      put("/1.1/#{account_id}/events/#{id}", event: params.merge(day: day, hours: hours, minutes: minutes))
    end

    def update_bulk_events(update)
      post("/1.1/#{account_id}/bulk/events", update: update)
    end
  end
end
