require "securerandom"
require "yaml"

module TimelyApp
  class CLI
    attr_reader :options, :client

    def initialize(options = {})
      @options = options
      @client = TimelyApp::Client.new(
        access_token: options[:access_token] || fetch_access_token,
        account_id: options[:account_id] || fetch_account_id,
        verbose: options[:verbose]
      )
    end

    def get_config(key)
      read_config_file&.fetch(key, nil)
    end

    def set_config(key, value)
      save_config_file(key => value)
    end

    def command_exists?(cmd)
      return false if cmd.nil? || cmd.empty?

      client.respond_to?(cmd)
    end

    def call(cmd, *args)
      client.send(cmd, *args)
    end

    def auth(client_id, client_secret)
      validate_auth_credentials!(client_id, client_secret)

      auth_client = TimelyApp::Client.new(verbose: options[:verbose])
      code = authorize_via_browser(auth_client, client_id)
      token = fetch_oauth_token(auth_client, client_id, client_secret, code)
      persist_or_print_token(token)
    rescue TimelyApp::Error => error
      handle_auth_failure(error, code)
    end

    private

    def validate_auth_credentials!(client_id, client_secret)
      return if client_id && client_secret

      puts "Usage: timely-app auth CLIENT_ID CLIENT_SECRET"
      exit 1
    end

    def authorize_via_browser(auth_client, client_id)
      auth_url = auth_client.get_oauth_authorize_url(
        client_id: client_id,
        redirect_uri: oauth_redirect_uri
      )
      puts "Visit this URL in your browser:"
      puts auth_url
      puts "\nEnter authorization code here:"
      gets.chomp
    end

    def oauth_redirect_uri
      "urn:ietf:wg:oauth:2.0:oob"
    end

    def fetch_oauth_token(auth_client, client_id, client_secret, code)
      auth_client.post_oauth_token(
        client_id: client_id,
        client_secret: client_secret,
        code: code,
        redirect_uri: oauth_redirect_uri,
        grant_type: "authorization_code"
      )
    end

    def persist_or_print_token(token)
      if options[:save]
        save_config_file(
          access_token: token.access_token,
          refresh_token: token.refresh_token,
          created_at: token.created_at
        )
      else
        puts "\nAccess token:\n#{token.access_token}\n"
      end
      puts "Authentication succeeded" if options[:verbose]
    end

    def handle_auth_failure(error, code)
      puts "Authentication failed"
      if options[:verbose]
        puts "Code: #{code}"
        puts "Response code: #{error.response.code}"
        puts "Response: #{error.response.body}"
      end
      exit 1
    end

    def config_file_path
      Dir.home + "/.timelyrc"
    end

    def read_config_file
      return unless File.exist?(config_file_path)

      config = YAML.safe_load_file(
        config_file_path,
        permitted_classes: [Symbol, Time],
        aliases: false
      )
      return {} unless config.is_a?(Hash)

      config.to_h { |key, value| [key.to_s, value] }
    end

    def fetch_account_id
      read_config_file&.fetch("account_id", nil)
    end

    def fetch_access_token
      read_config_file&.fetch("access_token", nil)
    end

    def check_access_token
      unless fetch_access_token
        puts "No access token found. Run `timely-app auth` to get one."
        exit 1
      end
    end

    def save_config_file(**options)
      config = read_config_file || {}
      config.merge!(options.to_h { |key, value| [key.to_s, value] })
      write_config_file(config.to_yaml)
      puts "Saved to #{config_file_path}"
    end

    def write_config_file(content)
      temporary_path = "#{config_file_path}.#{Process.pid}.#{SecureRandom.hex(8)}.tmp"

      File.open(temporary_path, File::WRONLY | File::CREAT | File::EXCL, 0o600) do |file|
        file.write(content)
        file.flush
        file.fsync
      end
      File.rename(temporary_path, config_file_path)
      File.chmod(0o600, config_file_path)
      sync_config_directory
    ensure
      File.delete(temporary_path) if temporary_path && File.exist?(temporary_path)
    end

    def sync_config_directory
      File.open(File.dirname(config_file_path), File::RDONLY, &:fsync)
    rescue Errno::EINVAL
      nil
    end
  end
end
