# frozen_string_literal: true

# https://dev.timelyapp.com/#clients
module TimelyApp
  class Client
    def create_client(name:, **params)
      post("/1.1/#{account_id}/clients", client: params.merge(name: name))
    end

    def get_clients(**params)
      get("/1.1/#{account_id}/clients", **params)
    end

    def get_client(id)
      get("/1.1/#{account_id}/clients/#{id}")
    end

    def update_client(id, name:, **params)
      put("/1.1/#{account_id}/clients/#{id}", client: params.merge(name: name))
    end
  end
end
