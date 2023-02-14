# frozen_string_literal: true

# https://dev.timelyapp.com/#labels
module TimelyApp
  class Client
    def create_label(name:, **params)
      post("/1.1/#{account_id}/labels", label: params.merge(name: name))
    end

    def delete_label(id)
      delete("/1.1/#{account_id}/labels/#{id}")
    end

    def get_child_labels(parent_id)
      get("/1.1/#{account_id}/labels", parent_id: parent_id)
    end

    def get_labels(**params)
      get("/1.1/#{account_id}/labels", params)
    end

    def get_label(id)
      get("/1.1/#{account_id}/labels/#{id}")
    end

    def update_label(id, name:, **params)
      put("/1.1/#{account_id}/labels/#{id}", label: params.merge(name: name))
    end
  end
end
