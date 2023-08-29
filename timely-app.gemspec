Gem::Specification.new do |gem|
  gem.name = "timely-app"
  gem.version = File.read(File.expand_path('../lib/timely-app.rb', __FILE__)).match(/VERSION\s*=\s*'(.*?)'/)[1]

  gem.license = "MIT"

  gem.platform = Gem::Platform::RUBY

  repository_url = "https://github.com/amkisko/timely_app.rb"

  gem.authors = ["Andrei Makarov"]
  gem.email = ["andrei@kiskolabs.com"]
  gem.homepage = repository_url
  gem.description = "Ruby client for the Timely API"
  gem.summary = "See description"
  gem.metadata = {
    "homepage" => repository_url,
    "source_code_uri" => repository_url,
    "bug_tracker_uri" => "#{repository_url}/issues",
    "changelog_uri" => "#{repository_url}/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  gem.files = Dir.glob("lib/**/*.rb") + Dir.glob("bin/**/*") + %w(CHANGELOG.md LICENSE.md README.md timely-app.gemspec)

  gem.bindir      = "bin"
  gem.executables = ["timely-app"]

  gem.required_ruby_version = ">= 1.9.3"
  gem.require_path = "lib"

  gem.add_development_dependency 'rspec-core', '~> 3'
  gem.add_development_dependency 'rspec-expectations', '~> 3'
  gem.add_development_dependency 'webmock', '~> 3'
  gem.add_development_dependency 'pry-byebug', '~> 3'
end
