%w(net/http cgi ostruct openssl base64).each {|l|require l}
module Queueue
  class Client
    class << self
      def configure
        @config = OpenStruct.new
        yield @config
        @http = Net::HTTP.new(@config.host, @config.port)
      end
          
      def create_queue(queue_name)
        path = "/?QueueName=#{queue_name}"
        @http.request_post(path, '', header('POST', '/'))
      end
    
      def list_queues(queue_name_prefix = nil)
        path = '/'
        path << "?QueueNamePrefix=#{queue_name_prefix}" if queue_name_prefix
        @http.request_get(path, header('GET', path))
      end

      def delete_queue(queue_url)
        @http.delete(queue_url, header('DELETE', queue_url))
      end

      def send_message(queue_url, message_body)
        message_body = "<Message>#{message_body}</Message>"
        path = "#{queue_url}/back"
        @http.request_put(path, message_body, header('PUT', path))
      end

      def set_visibility_timeout(queue_url, visibility_timeout)
        path = "#{queue_url}?VisibilityTimeout=#{visibility_timeout}"
        @http.request_put(path, '', header('PUT', queue_url))
      end

      def receive_message(queue_url, number_of_messages = nil, visibility_timeout = nil)
        path = auth_path = "#{queue_url}/front"
        path += '?' if number_of_messages || visibility_timeout
        path += "NumberOfMessages=#{number_of_messages}" if number_of_messages
        path += '&' if number_of_messages && visibility_timeout
        path += "VisibilityTimeout=#{visibility_timeout}" if visibility_timeout
        @http.request_get(path, header('GET', auth_path))
      end

      def get_visibility_timeout(queue_url)
        @http.request_get(queue_url, header('GET', queue_url))
      end

      def delete_message(queue_url, message_id)
        path = "#{queue_url}/#{CGI.escape(message_id)}"
        @http.delete(path, header('DELETE', path))
      end

      def peek_message(queue_url, message_id)
        path = "#{queue_url}/#{CGI.escape(message_id)}"
        @http.request_get(path, header('GET', path))
      end
      
      def header(http_method, path)
        header = {}
        header['Date'] = Time.now.strftime('%a, %d %b %Y %H:%M:%S %Z')
        header['Content-Type'] = 'text/plain'
        header['AWS-Version'] = '2006-04-01'
        digest = OpenSSL::Digest::Digest.new('sha1')
        headers = "#{http_method}\n\n#{header['Content-Type']}\n#{header['Date']}\n#{path}"
        hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, @config.secret_access_key, headers))
        header['Authorization'] = "AWS #{@config.access_key_id}:#{hmac}"
        header
      end
    end
  end
end

Queueue::Client.configure do |config|
#  config.host = 'queue.amazonaws.com'
#  config.port = '80'
  config.host = '127.0.0.1'
  config.port = '2323'
  config.access_key_id = 'queueue'
  config.secret_access_key = 'queueue'
end

QUEUE_URI = '/A23E9WXPHGOG29/rock'
MSG_ID = 'QY2W3KP5UP8JML168TIT|IZ4H6JOZT33QD8126S2Y|U18WDAVC8WN4AGL26IQ4'

# p Queueue::Client.create_queue('rock').body
# p Queueue::Client.delete_queue(QUEUE_URI).body
# p Queueue::Client.list_queues.body
# p Queueue::Client.send_message(QUEUE_URI, 'Lie detector').body
# p Queueue::Client.peek_message(QUEUE_URI, MSG_ID).body
# p Queueue::Client.receive_message(QUEUE_URI).body
# p Queueue::Client.delete_message(QUEUE_URI, MSG_ID).body
# p Queueue::Client.set_visibility_timeout(QUEUE_URI, 5).body
# p Queueue::Client.get_visibility_timeout(QUEUE_URI).body
# 5.times { |n| Queueue::Client.send_message(QUEUE_URI, "yeah #{n}") }
# p Queueue::Client.receive_message(QUEUE_URI, 5).body