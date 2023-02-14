#!/usr/bin/env ruby

require "sinatra"
require "timely-app"

class AppConfig
  CLIENT_ID = ENV.fetch("TIMELY_CLIENT_ID")
  CLIENT_SECRET = ENV.fetch("TIMELY_CLIENT_SECRET")
  REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"
end

set :bind, "0.0.0.0"
set :port, 3000

get "/" do
  <<-HTML
    <div>
      <a href="#{TimelyApp::Client.new.get_oauth_authorize_url(client_id: AppConfig::CLIENT_ID, redirect_uri: AppConfig::REDIRECT_URI)}" target="_blank">Sign in with Timely</a>
    </div>
    <div style="marging-top: 2rem;">
      <p>Enter authorization code here:</p>
      <form action="/callback" method="get">
        <div><textarea name="code" placeholder="Enter code here"></textarea></div>
        <div><input type="submit" value="Submit"></div>
      </form>
    </div>
  HTML
end

get "/callback" do
  token = TimelyApp::Client.new.post_oauth_token(client_id: AppConfig::CLIENT_ID, client_secret: AppConfig::CLIENT_SECRET, code: params["code"], redirect_uri: AppConfig::REDIRECT_URI, grant_type: "authorization_code")

  <<-HTML
    <div>
      <h1>Access token</h1>
      <pre>#{token.access_token}</pre>
    </div>
    <div style="margin-top: 3rem;">
      <h2>Token details</h2>
      <pre>#{JSON.pretty_generate(token.to_h)}</pre>
    </div>
  HTML
rescue TimelyApp::Error => e
  <<-HTML
    <p>Code: #{params["code"]}</p>
    <p>Response code: #{e.response.code}</p>
    <p>Response:</p>
    <pre>#{e.response.body}</pre>
  HTML
end
