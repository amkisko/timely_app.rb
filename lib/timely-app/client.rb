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
    DEFAULT_OPEN_TIMEOUT = 5
    DEFAULT_READ_TIMEOUT = 30
    FILTERED_VALUE = "[FILTERED]"
    SENSITIVE_FIELD = /authorization|code|credential|password|secret|token/i

    attr_accessor :account_id

    def initialize(options = {})
      @auth_header = "Authorization"
      @auth_value = "Bearer #{options[:access_token]}"
      @user_agent = options.fetch(:user_agent) { "timely-app/#{VERSION} ruby/#{RUBY_VERSION}" }

      @host = "api.timelyapp.com"
      @http = build_http(options)

      @account_id = options[:account_id]
      @verbose = options[:verbose] || !ENV["VERBOSE"].nil? || false
    end

    def get(path, params = nil)
      request(Net::HTTP::Get.new(Params.join(path, params)))
    end

    private

    def build_http(options)
      http = Net::HTTP.new(@host, Net::HTTP.https_default_port)
      http.use_ssl = true
      http.open_timeout = options.fetch(:open_timeout, DEFAULT_OPEN_TIMEOUT)
      http.read_timeout = options.fetch(:read_timeout, DEFAULT_READ_TIMEOUT)
      http
    end

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
      apply_request_headers(http_request, body_object)
      response = @http.request(http_request)
      log_verbose_exchange(http_request, response)
      raise Response.error(response) unless response.is_a?(Net::HTTPSuccess)

      Response.parse(response)
    end

    def apply_request_headers(http_request, body_object)
      http_request["User-Agent"] = @user_agent
      http_request[@auth_header] = @auth_value

      return unless body_object

      http_request["Content-Type"] = "application/json"
      http_request.body = JSON.generate(body_object)
    end

    def log_verbose_exchange(http_request, response)
      return unless verbose?

      puts ">> request: #{http_request.method} #{http_request.path} #{filtered_body(http_request.body)}"
      puts "<< response: #{http_request.method} #{http_request.path} #{response.code} #{filtered_body(response.body)}"
    end

    def filtered_body(body)
      return if body.nil? || body.empty?

      JSON.generate(filter_sensitive_values(JSON.parse(body)))
    rescue JSON::ParserError
      FILTERED_VALUE
    end

    def filter_sensitive_values(value)
      case value
      when Hash
        value.to_h { |key, nested_value|
          [key, key.match?(SENSITIVE_FIELD) ? FILTERED_VALUE : filter_sensitive_values(nested_value)]
        }
      when Array
        value.map { |nested_value| filter_sensitive_values(nested_value) }
      else
        value
      end
    end
  end
end
