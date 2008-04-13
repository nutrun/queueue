module Queueue
  module Http
    class User
      def self.authorized?(headers, signature)
        digest = OpenSSL::Digest::Digest.new('sha1')
        hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SECRET_ACCESS_KEY, headers)).strip
        hmac == signature
      end
    end
  end
end
