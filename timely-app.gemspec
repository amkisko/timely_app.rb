Gem::Specification.new do |gem|
  gem.name = "timely-app"
  gem.version = File.read(File.expand_path("../lib/timely-app.rb", __FILE__)).match(/VERSION\s*=\s*"(.*?)"/)[1]

  gem.license = "MIT"

  gem.platform = Gem::Platform::RUBY

  gem.authors = ["Andrei Makarov"]
  gem.email = ["contact@kiskolabs.com"]
  gem.homepage = "https://github.com/amkisko/timely_app.rb"
  gem.description = "Ruby client for the Timely API"
  gem.summary = "See description"
  gem.metadata = {
    "homepage" => "https://github.com/amkisko/timely_app.rb",
    "source_code_uri" => "https://github.com/amkisko/timely_app.rb",
    "bug_tracker_uri" => "https://github.com/amkisko/timely_app.rb/issues",
    "changelog_uri" => "https://github.com/amkisko/timely_app.rb/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  gem.files = Dir.glob("lib/**/*.rb") + Dir.glob("bin/**/*") + Dir.glob("sig/**/*.rbs") + %w[CHANGELOG.md LICENSE.md README.md timely-app.gemspec]

  gem.bindir = "bin"
  gem.executables = ["timely-app"]

  gem.required_ruby_version = ">= 2.5.0"
  gem.require_path = "lib"

  gem.add_development_dependency "rspec-core", "~> 3"
  gem.add_development_dependency "rspec-expectations", "~> 3"
  gem.add_development_dependency "rspec_junit_formatter", "~> 0.6"
  gem.add_development_dependency "simplecov", "~> 0.21"
  gem.add_development_dependency "simplecov-cobertura", "~> 2"
  gem.add_development_dependency "webmock", "~> 3"
  gem.add_development_dependency "pry", "~> 0.14"
  gem.add_development_dependency "standard", "~> 1.0"
  gem.add_development_dependency "rbs", "~> 3.0"
end
