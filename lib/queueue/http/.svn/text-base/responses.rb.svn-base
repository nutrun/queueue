module Queueue::Http
  class Responses
    class << self
      def create_queue(queue_url, request_id)
        with_doc do |doc|
          response = doc.add_element('CreateQueueResponse')
          response.add_namespace('http://queue.amazonaws.com/doc/2006-04-01/')
          response.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
          response.add_attribute('xsi:type', 'CreateQueueResponse')
          response.add_element('QueueUrl').add_text(queue_url)
          add_status(response, request_id)
        end
      end

      def list_queues(queues, request_id)
        with_doc do |doc|
          response = doc.add_element('ListQueuesResponse')
          queues_elem = response.add_element('Queues')
          queues.each {|q| queues_elem.add_element('QueueUrl').add_text(q.url)}
          add_status(response, request_id)
        end
      end

      def delete_queue(request_id)
        with_doc do |doc|
          response = doc.add_element('DeleteQueueResponse')
          add_status(response, request_id)
        end
      end

      def send_message(message_id, request_id)
        with_doc do |doc|
          response = doc.add_element('SendMessageResponse')
          response.add_element('MessageId').add_text(message_id)
          add_status(response, request_id)
        end
      end

      def set_visibility_timeout(request_id)
        with_doc do |doc|
          response = doc.add_element('SetVisibilityTimeoutResponse')
          add_status(response, request_id)
        end
      end

      def receive_message(messages, request_id)
        with_doc do |doc|
          response = doc.add_element('ReceiveMessageResponse')
          messages.each do |msg|
            message = response.add_element('Message')
            message.add_element('MessageId').add_text(msg.message_id)
            message.add_element('MessageBody').add_text(msg.body)
          end
          add_status(response, request_id)
        end
      end

      def get_visibility_timeout(timeout, request_id)
        with_doc do |doc|
          response = doc.add_element('GetVisibilityTimeoutResponse')
          response.add_element('VisibilityTimeout').add_text(timeout)
          add_status(response, request_id)
        end
      end

      def delete_message(request_id)
        with_doc do |doc|
          response = doc.add_element('DeleteMessageResponse')
          add_status(response, request_id)
        end
      end

      def peek_message(msg, request_id)
        with_doc do |doc|
          response = doc.add_element('PeekMessageResponse')
          message = response.add_element('Message')
          message.add_element('MessageId').add_text(msg.message_id)
          message.add_element('MessageBody').add_text(msg.body)
          add_status(response, request_id)
        end
      end

      def error(code, message, request_id)
        with_doc do |doc|
          response = doc.add_element('Response')
          errors = response.add_element('Errors')
          error = errors.add_element('Error')
          error.add_element('Code').add_text(code)
          error.add_element('Message').add_text(message)
          response.add_element('RequestID').add_text(request_id)          
        end
      end

      private

      def add_status(response, request_id)
        status = response.add_element('ResponseStatus')
        status.add_element('StatusCode').add_text('Success')
        status.add_element('RequestID').add_text(request_id)
      end
      
      def with_doc(&block)
        doc = REXML::Document.new
        yield doc
        doc.to_s
      end
    end
  end
end
