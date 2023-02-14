# frozen_string_literal: true

# https://dev.timelyapp.com/#webhooks
module TimelyApp
  class Client
    def create_webhook(url:, **params)
      post("/1.1/#{account_id}/webhooks", webhook: params.merge(url: url))
    end

    def delete_webhook(id)
      delete("/1.1/#{account_id}/webhooks/#{id}")
    end

    def get_webhooks(**params)
      get("/1.1/#{account_id}/webhooks", params)
    end

    def get_webhook(id)
      get("/1.1/#{account_id}/webhooks/#{id}")
    end

    def update_webhook(id, url:, **params)
      put("/1.1/#{account_id}/webhooks/#{id}", webhook: params.merge(url: url))
    end
  end
end
