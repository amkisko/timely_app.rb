# frozen_string_literal: true

# https://dev.timelyapp.com/#permissions
module TimelyApp
  class Client
    def get_current_user_permissions
      get("/1.1/#{account_id}/users/current/permissions")
    end

    def get_user_permissions(user_id:)
      get("/1.1/#{account_id}/users/#{user_id}/permissions")
    end
  end
end
