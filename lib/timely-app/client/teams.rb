# frozen_string_literal: true

# https://dev.timelyapp.com/#teams
module TimelyApp
  class Client
    def create_team(name:, users:, **params)
      post("/1.1/#{account_id}/teams", team: params.merge(name: name, users: users))
    end

    def delete_team(id)
      delete("/1.1/#{account_id}/teams/#{id}")
    end

    def get_teams(**params)
      get("/1.1/#{account_id}/teams", params)
    end

    def get_team(id)
      get("/1.1/#{account_id}/teams/#{id}")
    end

    def update_team(id, name:, users:, **params)
      put("/1.1/#{account_id}/teams/#{id}", team: params.merge(name: name, users: users))
    end
  end
end
