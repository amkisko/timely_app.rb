# CHANGELOG

## 1.3.2 (2026-07-25)

- BREAKING: Require Ruby 3.4 or newer
- Fix `get_clients` to call `/1.1/:account_id/clients` instead of `/1.1/accounts`
- Move `TimelyApp::Cli` under `lib/`

## 1.3.1 (2023-09-30)

- Refresh gemfile lock

## 1.3.0 (2023-08-30)

- Set minimum ruby version requirement to 2.5.0

## 1.2.0 (2023-08-29)

- Fix version definition

## 1.1.1 (2023-08-29)

- Update gem configuration

## 1.1.0 (2023-08-15)

- Update ruby version to 3.2.2
- Update dependencies

## 1.0.5 (2023-03-02)

- Fix verbose mode check

## 1.0.4 (2023-02-14)

- Update CLI to check input properly and handle command arguments

## 1.0.3 (2023-02-14)

- Fix gemspec

## 1.0.2 (2023-02-14)

- Add basic CLI script `timely-app`

## 1.0.1 (2023-02-14)

- Fix oauth token request
- Add example web service for CLI authorization

## 1.0.0 (2023-02-14)

- Initial version
