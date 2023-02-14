# frozen_string_literal: true

# https://dev.timelyapp.com/#roles
module TimelyApp
  class Client
    def get_roles
      get("/1.1/#{account_id}/roles")
    end
  end
end
