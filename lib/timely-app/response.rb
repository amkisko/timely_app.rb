# frozen_string_literal: true

require "net/http"
require "json"

module TimelyApp
  module Response
    extend self

    def parse(response)
      if response.is_a?(Net::HTTPNoContent)
        return :no_content
      end

      if response.content_type == "application/json"
        object = JSON.parse(response.body, symbolize_names: true, object_class: Record)

        if response["Link"]
          object.singleton_class.module_eval { attr_accessor :link }
          object.link = LinkHeader.parse(response["Link"])
        end

        return object
      end

      response.body
    end

    def error(response)
      body = error_body(response)
      errors = body["errors"]
      message = errors.is_a?(Hash) ? errors["message"] : nil
      message ||= body["error_description"]
      error_class(response).new(message, response: response, errors: errors)
    end

    def error_body(response)
      return {} unless response.content_type == "application/json"

      body = JSON.parse(response.body.to_s)
      body.is_a?(Hash) ? body : {}
    rescue JSON::ParserError
      {}
    end

    def error_class(object)
      case object
      when Net::HTTPBadRequest then TimelyApp::ClientError
      when Net::HTTPUnauthorized then TimelyApp::UnauthorizedError
      when Net::HTTPForbidden then TimelyApp::ForbiddenError
      when Net::HTTPNotFound then TimelyApp::NotFoundError
      when Net::HTTPClientError then TimelyApp::ClientError
      when Net::HTTPServerError then TimelyApp::ServerError
      else
        TimelyApp::Error
      end
    end
  end

  private_constant :Response
end
