module Queueue
  class QueueService
    class << self      
      # Create and return a new Queue. If a Queue with the same name already exists,
      # it will be overwritten by the new one.
      def create_queue(name)
        queue = Queue.new(name)
        queues[name] = queue
        queue
      end

      # Deleted named Qeueue.
      # A NonEmptyQueue exception will be raised if the Queue contains messages. 
      # A NonEmptyQueue Exception will be raised
      # if the specified Queue does not exist
      def delete_queue(queue_name)
        raise NonEmptyQueue unless find_queue(queue_name).empty?
        queues.delete(queue_name)
      end

      # Set the Visibility Timeout (in seconds) on the named Queue.
      # A NonExistentQueue Exception will be raised if the specified 
      # Queue does not exist.
      def set_visibility_timeout(queue_name, timeout)
        find_queue(queue_name).visibility_timeout = timeout
      end

      # Get the Visibility Timeout (in seconds) of the named Queue.
      # A NonExistentQueue Exception will be raised if the specified 
      # Queue does not exist.
      def get_visibility_timeout(queue_name)
        find_queue(queue_name).visibility_timeout
      end

      # Send a message to the named Queue. 
      # A NonExistentQueue Exception will be raised if the specified 
      # Queue does not exist.
      def send_message(queue_name, message_body)
        find_queue(queue_name).receive(message_body)
      end

      # Delete a Message from the named Queue.
      # A NonExistentQueue Exception will be raised if the specified 
      # Queue does not exist.
      # Nothing will happen if the specified message does not exist.
      def delete_message(queue_name, message_id)
        find_queue(queue_name).delete(message_id)
      end

      # Receive a number of messages from the named Queue. 
      # If a Visibility Timeout is provided, it will be set
      # on the returned messages. 
      # <b>Visible</b> messages are returned on a first-received, first-served basis.
      # A NonExistentQueue Exception will be raised if the specified 
      # Queue does not exist.
      def receive_message(queue_name, number_of_messages = nil, visibility_timeout = nil)
        find_queue(queue_name).queued_messages(number_of_messages, visibility_timeout)
      end

      # Get message on named Queue.
      # A NonExistentQueue Exception will be raised if the specified 
      # Queue does not exist.
      def peek_message(queue_name, message_id)
        find_queue(queue_name).message(message_id)
      end

      # List available Queues. 
      # If a Queue name prefix is provided, only Queues whose names
      # start with this prefix will be listed. 
      def list_queues(queue_name_prefix = nil)
        if queue_name_prefix
          queues.values.select {|q| q.name =~ /^#{queue_name_prefix}.*/}
        else
          queues.values
        end
      end

      private
      
      def queues
        @queues ||= {}
      end

      def find_queue(queue_name)
        queues[queue_name] || raise(NonExistentQueue)
      end
      
      def reset!
        @queues = {}
      end
    end
  end
  
  QS = QueueService
end