# timely-app

[![Gem Version](https://badge.fury.io/rb/timely-app.svg)](https://badge.fury.io/rb/timely-app) [![Test Status](https://github.com/amkisko/timely-app/actions/workflows/test.yml/badge.svg)](https://github.com/amkisko/timely-app/actions/workflows/test.yml) [![codecov](https://codecov.io/gh/amkisko/timely_app.rb/graph/badge.svg?token=QL3A7ATCRK)](https://codecov.io/gh/amkisko/timely_app.rb)

Ruby client for the [Timely API](https://dev.timelyapp.com).

Sponsored by [Kisko Labs](https://www.kiskolabs.com).

## Install

Using Bundler:
```sh
bundle add timely-app
```

Using RubyGems:
```sh
gem install timely-app
```

## Usage for CLI

Register your local service at https://app.timelyapp.com/{account_id}/oauth_applications

Install `timely-app` gem as dependency or globally.

Run auth:

```sh
TIMELY_CLIENT_ID=<client_id> TIMELY_CLIENT_SECRET=<client_secret> bundle exec timely-app auth -s
```

## Usage for web service

Example web server: `./examples/auth_server.rb`

Implement link to Timely OAuth authorization page:

```ruby
<%= link_to "Sign in with Timely", TimelyApp::Client.new.get_oauth_authorize_url(client_id: ENV.fetch("TIMELY_CLIENT_ID"), redirect_uri: ENV.fetch("TIMELY_REDIRECT_URI")) %>
```

Implement callback action to get access token (devise example):

```ruby
def timely_auth_callback
  skip_verify_authorized!

  client = TimelyApp::Client.new
  token = client.post_oauth_token(client_id: ENV.fetch("TIMELY_CLIENT_ID"), client_secret: ENV.fetch("TIMELY_CLIENT_SECRET"), code: params["code"], redirect_uri: ENV.fetch("TIMELY_REDIRECT_URI"), grant_type: "authorization_code")

  if token["access_token"].present?
    client.access_token = token["access_token"]
    timely_user = client.get_current_user

    user = User.find_or_create_by(email: timely_user["email"])
    user.update!(timely_id: timely_user["id"], timely_access_token: token["access_token"], timely_refresh_token: token["refresh_token"])

    sign_in(user)

    redirect_to "/authorized"
  else
    redirect_to "/not-authorized"
  end
rescue TimelyApp::Error => _e
  redirect_to "/not-authorized"
end
```

## Client usage

```ruby
timely = TimelyApp::Client.new(access_token: <USER_TOKEN_AFTER_OAUTH>, account_id: <ACCOUNT_ID>)

timely.get_projects.each do |project|
  puts project.name
end
```

## How to test callbacks

You can use [localhost.run](https://localhost.run/) to test callbacks locally.

There are large list of available tools for tunneling: [awesome-tunneling](https://github.com/anderspitman/awesome-tunneling)

## Acknowledgment

- thanks to [timcraft](https://github.com/timcraft) and the team for [Noko API client](https://github.com/timcraft/noko) that was used as starting point

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amkisko/timely-app

## Publishing

```sh
rm timely-app-*.gem
gem build timely-app.gemspec
gem push timely-app-*.gem
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
