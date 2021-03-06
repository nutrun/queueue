module Queueue::Http
  class RequestValidator
    include IdGenerator
    
    def initialize(env)
      @env = env
    end
    
    def authorized?
      Queueue::Http::User.authorized?(canonicalized_headers, signature)
    end

    def auth_failure
      Responses.error(
        'AuthFailure', 
        'The provided signature is not valid for this access token', 
        request_id
      )
    end

    def date_valid?
      valid = /([a-zA-Z]{3}, [0-9]{1,2} [a-zA-Z]{3} [0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2} [A-Z]{3})/
      !!(@env['HTTP_DATE'] =~ valid)
    end

    def invalid_date
      Responses.error(
        "InvalidHttpRequest", 
        "The HTTP request is invalid. Reason: Invalid date in header date",
        request_id
      )
    end
    
    private
    
    def canonicalized_headers
      %w(REQUEST_METHOD HTTP_MD5 CONTENT_TYPE HTTP_DATE REQUEST_PATH).map do |h|
        @env[h]
      end * "\n"
    end
    
    def signature
      @env["HTTP_AUTHORIZATION"].split(':')[1]
    rescue
      "noyourenot"
    end
  end
end