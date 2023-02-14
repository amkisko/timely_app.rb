# frozen_string_literal: true

# https://dev.timelyapp.com/#users
module TimelyApp
  class Client
    def create_user(name:, email:, role_id:, **params)
      post("/1.1/#{account_id}/users", user: params.merge(name: name, email: email, role_id: role_id))
    end

    def delete_user(id)
      delete("/1.1/#{account_id}/users/#{id}")
    end

    def get_users(**params)
      get("/1.1/#{account_id}/users", params)
    end

    def get_user(id)
      get("/1.1/#{account_id}/users/#{id}")
    end

    def get_current_user
      get("/1.1/#{account_id}/users/current")
    end

    def update_user(id, name:, email:, role_id:, **params)
      put("/1.1/#{account_id}/users/#{id}", user: params.merge(name: name, email: email, role_id: role_id))
    end
  end
end
