#!/usr/bin/env ruby

require "timely-app"

class AppConfig
  CLIENT_ID = ENV.fetch("TIMELY_CLIENT_ID")
  CLIENT_SECRET = ENV.fetch("TIMELY_CLIENT_SECRET")
  REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"
end

auth_url = TimelyApp::Client.new.get_oauth_authorize_url(
  client_id: AppConfig::CLIENT_ID,
  redirect_uri: AppConfig::REDIRECT_URI
)

puts "Visit this URL in your browser:"
puts auth_url
puts

puts "Enter authorization code here:"
code = gets.chomp
puts

begin
  token = TimelyApp::Client.new.post_oauth_token(
    client_id: AppConfig::CLIENT_ID,
    client_secret: AppConfig::CLIENT_SECRET,
    code: code,
    redirect_uri: AppConfig::REDIRECT_URI,
    grant_type: "authorization_code"
  )
  puts "Access token: #{token.access_token}"
  puts
  puts "Token details: #{token.to_h}"
rescue TimelyApp::Error => e
  puts "Code: #{code}"
  puts "Response code: #{e.response.code}"
  puts "Response:"
  puts e.response.body
  exit 1
end
