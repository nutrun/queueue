module Queueue::Http
  class Adapter
    extend IdGenerator

    class << self
      def create_queue(queue_name)
        safe do
          queue = service.create_queue(queue_name)
          respond.create_queue(queue.url, request_id)
        end
      end

      def list_queues(queue_name_prefix)
        safe do
          queues = service.list_queues(queue_name_prefix)
          respond.list_queues(queues, request_id)
        end
      end

      def get_visibility_timeout(queue_name)
        safe do
          timeout = service.get_visibility_timeout(queue_name)
          respond.get_visibility_timeout(timeout.to_s, request_id)
        end
      end

      def receive_message(queue_name, number_of_messages, visibility_timeout)
        safe do
          messages = service.receive_message(
            queue_name, 
            number_of_messages, 
            visibility_timeout
          )
          respond.receive_message(messages, request_id)
        end
      end

      def peek_message(queue_name, message_id)
        safe do
          message = service.peek_message(queue_name, message_id)
          respond.peek_message(message, request_id)
        end
      end

      def delete_queue(queue_name)
        safe do
          service.delete_queue(queue_name)
          respond.delete_queue(request_id)
        end
      end

      def delete_message(queue_name, message_id)
        safe do
          service.delete_message(queue_name, message_id)
          respond.delete_message(request_id)
        end
      end

      def send_message(queue_name, message_body)
        safe do
          message_id = service.send_message(queue_name, message_body)
          respond.send_message(message_id, request_id)
        end
      end

      def set_visibility_timeout(queue_name, visibility_timeout)
        safe do
          service.set_visibility_timeout(queue_name, visibility_timeout)
          respond.set_visibility_timeout(request_id)
        end
      end

      private

      def service
        Queueue::QS
      end

      def respond
        Queueue::Http::Responses
      end

      def safe(&block)
        begin
          yield
        rescue Exception => e
          code = e.class.name.split('::')[1]
          respond.error(code, e.message, request_id)
        end
      end
    end
  end
end