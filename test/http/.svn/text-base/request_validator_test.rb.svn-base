require File.dirname(__FILE__) + "/test_helper"

module Queueue::Http
  class RequestValidatorTest < Test::Unit::TestCase
    def test_invalid_date
      assert(!RequestValidator.new({'HTTP_DATE' => '14/03/87'}).date_valid?)
    end
    
    def test_bad_auth
      assert(!RequestValidator.new({}).authorized?)
    end
  end
end