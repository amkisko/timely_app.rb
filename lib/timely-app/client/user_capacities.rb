# frozen_string_literal: true

# https://dev.timelyapp.com/#user_capacities
module TimelyApp
  class Client
    def get_users_capacities(**params)
      get("/1.1/#{account_id}/users/capacities", params)
    end

    def get_user_capacities(user_id:)
      get("/1.1/#{account_id}/users/#{user_id}/capacities")
    end
  end
end
