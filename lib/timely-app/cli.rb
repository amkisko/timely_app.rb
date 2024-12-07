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
      if !client_id || !client_secret
        puts "Usage: timely-app auth CLIENT_ID CLIENT_SECRET"
        exit 1
      end

      auth_client = TimelyApp::Client.new(verbose: options[:verbose])
      auth_url = auth_client.get_oauth_authorize_url(
        client_id: client_id,
        redirect_uri: "urn:ietf:wg:oauth:2.0:oob"
      )
      puts "Visit this URL in your browser:"
      puts auth_url
      puts "\nEnter authorization code here:"
      code = gets.chomp
      begin
        token = auth_client.post_oauth_token(
          client_id: client_id,
          client_secret: client_secret,
          code: code,
          redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
          grant_type: "authorization_code"
        )
        if options[:save]
          save_config_file(
            access_token: token.access_token,
            refresh_token: token.refresh_token,
            created_at: token.created_at
          )
        else
          puts "\nAccess token:\n#{token.access_token}\n"
        end
        if options[:verbose]
          puts "Token details: #{token.to_h}"
        end
      rescue TimelyApp::Error => e
        puts "Authentication failed"
        if options[:verbose]
          puts "Code: #{code}"
          puts "Response code: #{e.response.code}"
          puts "Response: #{e.response.body}"
        end
        exit 1
      end
    end

    private

    def config_file_path
      Dir.home + "/.timelyrc"
    end

    def read_config_file
      if File.exist?(config_file_path)
        YAML.load_file(config_file_path)
      end
    end

    def fetch_account_id
      read_config_file&.fetch("account_id", nil)
    end

    def fetch_access_token
      read_config_file&.fetch("access_token", nil)
    end

    def check_access_token
      if !fetch_access_token
        puts "No access token found. Run `timely-app auth` to get one."
        exit 1
      end
    end

    def save_config_file(**options)
      config = read_config_file || {}
      config.merge!(options)
      File.open(config_file_path, "w") do |f|
        f.write(config.to_yaml)
      end
      puts "Saved to #{config_file_path}"
    end
  end
end
