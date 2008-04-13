require File.dirname(__FILE__) + "/test_helper"

module Queueue::Http
  class UserTest < Test::Unit::TestCase
    def test_authorization
      headers = 'idontcare'
      digest = OpenSSL::Digest::Digest.new 'sha1'
      sig = Base64.encode64(OpenSSL::HMAC.digest(digest, SECRET_ACCESS_KEY, headers)).strip
      assert User.authorized?(headers, sig)
    end
  end
end
