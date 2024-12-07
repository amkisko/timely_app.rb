# frozen_string_literal: true

# https://dev.timelyapp.com/#accounts
module TimelyApp
  class Client
    def get_accounts
      get("/1.1/accounts")
    end

    def get_account_activities(account_id, **params)
      get("/1.1/#{account_id}/activities", params)
    end

    def get_account(id)
      get("/1.1/accounts/#{id}")
    end
  end
end
