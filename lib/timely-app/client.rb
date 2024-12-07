# frozen_string_literal: true

require "timely-app/errors"
require "timely-app/link_header"
require "timely-app/params"
require "timely-app/record"
require "timely-app/response"
require "net/http"
require "json"

module TimelyApp
  class Client
    attr_accessor :account_id

    def initialize(options = {})
      @auth_header = "Authorization"
      @auth_value = "Bearer #{options[:access_token]}"
      @user_agent = options.fetch(:user_agent) { "timely-app/#{VERSION} ruby/#{RUBY_VERSION}" }

      @host = "api.timelyapp.com"

      @http = Net::HTTP.new(@host, Net::HTTP.https_default_port)
      @http.use_ssl = true

      @account_id = options[:account_id]
      @verbose = options[:verbose] || !ENV["VERBOSE"].nil? || false
    end

    def get(path, params = nil)
      request(Net::HTTP::Get.new(Params.join(path, params)))
    end

    private

    def verbose?
      @verbose == true
    end

    def host_uri_join(path, params)
      URI.join("https://#{@host}", Params.join(path, params)).to_s
    end

    def post(path, attributes)
      request(Net::HTTP::Post.new(path), attributes)
    end

    def put(path, attributes = nil)
      request(Net::HTTP::Put.new(path), attributes)
    end

    def delete(path)
      request(Net::HTTP::Delete.new(path))
    end

    def request(http_request, body_object = nil)
      http_request["User-Agent"] = @user_agent
      http_request[@auth_header] = @auth_value

      if body_object
        http_request["Content-Type"] = "application/json"
        http_request.body = JSON.generate(body_object)
      end

      response = @http.request(http_request)

      if verbose?
        puts ">> request: #{http_request.method} #{http_request.path} #{http_request.body}"
        puts "<< response: #{http_request.method} #{http_request.path} #{response.code} #{response.body}"
      end

      raise Response.error(response) unless response.is_a?(Net::HTTPSuccess)

      Response.parse(response)
    end
  end
end
