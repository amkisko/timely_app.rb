# frozen_string_literal: true

# https://dev.timelyapp.com/#projects
module TimelyApp
  class Client
    def create_project(name:, color:, client_id:, users:, **params)
      post("/1.1/#{account_id}/projects", project: params.merge(name: name, color: color, client_id: client_id, users: users))
    end

    def delete_project(id)
      delete("/1.1/#{account_id}/projects/#{id}")
    end

    def get_projects(**params)
      get("/1.1/#{account_id}/projects", params)
    end

    def get_project(id)
      get("/1.1/#{account_id}/projects/#{id}")
    end

    def update_project(id, name:, color:, client_id:, users:, **params)
      put("/1.1/#{account_id}/projects/#{id}", project: params.merge(name: name, color: color, client_id: client_id, users: users))
    end
  end
end
