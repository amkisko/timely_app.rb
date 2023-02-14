# frozen_string_literal: true

# https://dev.timelyapp.com/#reports
module TimelyApp
  class Client
    def get_reports(**params)
      post("/1.1/#{account_id}/reports", params)
    end

    def get_filter_reports(**params)
      post("/1.1/#{account_id}/reports/filter", params)
    end
  end
end
