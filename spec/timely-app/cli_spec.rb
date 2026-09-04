require "spec_helper"
require "timely-app/cli"
require "tmpdir"

RSpec.describe TimelyApp::CLI do
  around do |example|
    original_home = ENV["HOME"]
    original_umask = File.umask(0o022)

    Dir.mktmpdir do |directory|
      ENV["HOME"] = directory
      example.run
    end
  ensure
    ENV["HOME"] = original_home
    File.umask(original_umask)
  end

  it "stores configuration keys consistently in a private file", :aggregate_failures do
    cli = described_class.new(access_token: "token", account_id: "account")

    cli.set_config(:access_token, "saved-token")

    expect(cli.get_config("access_token")).to eq("saved-token")
    expect(File.stat(File.join(Dir.home, ".timelyrc")).mode & 0o777).to eq(0o600)
  end

  it "tightens permissions on an existing configuration file", :aggregate_failures do
    config_path = File.join(Dir.home, ".timelyrc")
    File.write(config_path, {"access_token" => "old-token"}.to_yaml)
    File.chmod(0o644, config_path)
    cli = described_class.new(access_token: "token", account_id: "account")

    cli.set_config("access_token", "new-token")

    expect(File.stat(config_path).mode & 0o777).to eq(0o600)
    expect(cli.get_config("access_token")).to eq("new-token")
  end
end
