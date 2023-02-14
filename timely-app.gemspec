Gem::Specification.new do |s|
  s.name = "timely-app"
  s.version = "1.0.3"

  s.license = "MIT"

  s.platform = Gem::Platform::RUBY

  s.authors = ["Andrei Makarov"]
  s.email = ["andrei@kiskolabs.com"]
  s.homepage = "https://github.com/amkisko/timely-app"
  s.description = "Ruby client for the Timely API"
  s.summary = "See description"
  s.metadata = {
    "homepage" => "https://github.com/amkisko/timely-app",
    "source_code_uri" => "https://github.com/amkisko/timely-app",
    "bug_tracker_uri" => "https://github.com/amkisko/timely-app/issues",
    "changelog_uri" => "https://github.com/amkisko/timely-app/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  s.files = Dir.glob("lib/**/*.rb") + Dir.glob("bin/**/*") + %w(CHANGELOG.md LICENSE.md README.md timely-app.gemspec)

  s.bindir      = "bin"
  s.executables = ["timely-app"]

  s.required_ruby_version = ">= 1.9.3"
  s.require_path = "lib"
end
