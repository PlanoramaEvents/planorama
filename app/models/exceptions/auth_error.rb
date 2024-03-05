module Exceptions
  class AuthError < StandardError
    def initialize(msg="This is a custom exception", code)
      super(msg)
      @code = code
    end

    attr_reader :code
  end
end
