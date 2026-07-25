require "rspec_junit_formatter" if ENV["CI"]

if ENV["CI"]
  RSpec.configure do |config|
    config.add_formatter RspecJunitFormatter, "coverage/junit-coverage.xml"
  end
end
