module TimelyApp
  class Error < StandardError
    attr_reader :response, :errors

    def initialize(message = nil, response:, errors: nil)
      @response = response
      @errors = errors

      super(message)
    end
  end

  ClientError = Class.new(Error)

  ServerError = Class.new(Error)

  UnauthorizedError = Class.new(ClientError)

  NotFoundError = Class.new(ClientError)
  ForbiddenError = Class.new(ClientError)
end
