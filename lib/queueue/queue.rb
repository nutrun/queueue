module Queueue
  class Queue
    attr_reader :name, :messages, :visibility_timeout
    
    # Create named Queue. An InvalidParameterValue Exception will be raised
    # if the specified Queue name is not between 1 and 80 characters long.
    # The Visibility Timeout for the Queue is set a default 30 seconds
    def initialize(queue_name)
      raise InvalidParameterValue.new("QueueName") if queue_name.nil? || !(1..80).include?(queue_name.size)
      @name, @messages, @visibility_timeout = queue_name, [], 30
    end
    
    # Peek a Message providing the Message's id.
    # A MessageNotFound Exception will be raised if no message with the specified
    # id exists.
    def message(message_id)
      raise MissingParameter.new("MessageId") unless message_id
      @messages.find {|m| m.message_id == message_id} || raise(MessageNotFound)
    end
    
    # Get a number of <b>visible</b> Messages and set the Visibility Timeout on
    # them. If number of Messages is not explicitly scpecified, one message is 
    # returned. If the Visibility Timeout is not explicitly specified, the
    # Queue's current Visibility Timeout will be used.
    # Returned Messages will be locked for an amount of time equal to the
    # Visibility Timeout. These messages will not be visible on subsequent calls
    # to queued_messages, until the Visibility Timeout expires. 
    def queued_messages(number_of_messages, visibility_timeout)
      number_of_messages ||= 1
      visibility_timeout ||= self.visibility_timeout
      raise InvalidParameterValue.new("NumberOfMessages") if number_of_messages > 256
      raise InvalidParameterValue.new("VisibilityTimeout") if visibility_timeout > 86400
      @messages.select {|m| !m.locked?}[0, number_of_messages].map do |message|
        message.visibility_timeout = visibility_timeout
        message.lock!
        message
      end
    end
    
    # Push a Message to the Queue. Returns the new Message's id. 
    # The Queue's default Visibility Timeout is set on the Message.
    def receive(message_body)
      message = Message.new(message_body, visibility_timeout)
      @messages.push(message)
      message.message_id
    end
    
    # Delete a Message from the Queue.
    # Nothing will happen if the specified message does not exist.
    def delete(message_id)
      @messages.delete_if {|m| m.message_id == message_id}
    end
    
    # Returns true if the Queue does not contain any messages.
    def empty?
      @messages.empty?
    end
    
    # Set the Queue's Visibility Timeout. A InvalidParameterValue exception
    # will be raised if the specified Visibility Timeout is greater than
    # 86400 seconds
    def visibility_timeout=(visibility_timeout)
      raise InvalidParameterValue.new("VisibilityTimeout") if visibility_timeout > 86400
      @visibility_timeout = visibility_timeout
    end
  end
  
  class Message
    attr_reader :body, :message_id
    attr_accessor :visibility_timeout
    
    # A MissingParameter exception will be raised, unless the Message has 
    # a body.
    def initialize(body, timeout)
      raise MissingParameter.new("MessageBody") unless body
      @body, @visibility_timeout, @message_id = body, timeout, generate_id
      @lock_timestamp = 0
    end
    
    # Prevent the message from being viewed for the duration of the Message's
    # Visibility Timeout.
    def lock!
      @lock_timestamp = Time.now
    end
    
    # True if the Message's Visibility Timeout has not expired.
    def locked?
      (Time.now - @lock_timestamp).to_i < @visibility_timeout
    end
    
    private
    
    def generate_id
      chars = ('A'..'Z').to_a + ('1'..'9').to_a
      Array.new(3).map {Array.new(20).map {chars[rand(chars.size)]}.join}.join('|')
    end
  end
end