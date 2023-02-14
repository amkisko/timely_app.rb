# frozen_string_literal: true

# https://dev.timelyapp.com/#forecasts
module TimelyApp
  class Client
    def create_forecast(project_id:, **params)
      post("/1.1/#{account_id}/forecasts", forecast: params.merge(project_id: project_id))
    end

    def delete_forecast(id)
      delete("/1.1/#{account_id}/forecasts/#{id}")
    end

    def get_forecasts(**params)
      get("/1.1/#{account_id}/forecasts", params)
    end

    def update_forecast(id, project_id:, estimated_minutes:, **params)
      put("/1.1/#{account_id}/forecasts/#{id}", forecast: params.merge(project_id: project_id, estimated_minutes: estimated_minutes))
    end
  end
end
