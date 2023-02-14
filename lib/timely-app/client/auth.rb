# frozen_string_literal: true

# https://dev.timelyapp.com/#authentication
module TimelyApp
  class Client
    def get_oauth_authorize_url(client_id:, redirect_uri:)
      host_uri_join(
        "/1.1/oauth/authorize",
        response_type: 'code',
        redirect_uri: redirect_uri,
        client_id: client_id
      )
    end

    def post_oauth_token(client_id:, client_secret:, code:, redirect_uri:, grant_type: "authorization_code")
      post(
        "/1.1/oauth/token",
        redirect_uri: redirect_uri,
        code: code,
        client_id: client_id,
        client_secret: client_secret,
        grant_type: grant_type
      )
    end
  end
end
