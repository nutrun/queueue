require File.dirname(__FILE__) + "/test_helper"

module Queueue::Http
  class AdapterTest < Test::Unit::TestCase
    def test_creates_queue
      queue = Queueue::Queue.new('rock')
      Queueue::QS.expects(:create_queue).with("q_name").returns(queue)
      Adapter.create_queue('q_name')
    end
    
    def test_lists_queues
      Queueue::QS.expects(:list_queues).returns([])
      Adapter.list_queues nil
    end
    
    def test_lists_queues_with_prefix
      Queueue::QS.expects(:list_queues).with("prefix").returns([])
      Adapter.list_queues("prefix")
    end
    
    def test_gets_visibility_timeout
      Queueue::QS.expects(:get_visibility_timeout).with("q_name")
      Adapter.get_visibility_timeout("q_name")
    end
    
    def test_receives_message
      Queueue::QS.expects(:receive_message).with('q_name', nil, nil).returns([])
      Adapter.receive_message("q_name", nil, nil)
    end
    
    def test_receives_max_number_of_messages
      Queueue::QS.expects(:receive_message).with('q_name', 5, nil).returns([])
      Adapter.receive_message("q_name", 5, nil)
    end
    
    def test_receives_messages_setting_visibility_timeout
      Queueue::QS.expects(:receive_message).with('q_name', 1, 5).returns([])
      Adapter.receive_message("q_name", 1, 5)
    end
    
    def test_peeks_message
      message = Queueue::Message.new("body", 5)
      Queueue::QS.expects(:peek_message).with("q_name", "msg_id").returns(message)
      Adapter.peek_message("q_name", "msg_id")
    end
    
    def test_deletes_queue
      Queueue::QS.expects(:delete_queue).with('q_name')
      Adapter.delete_queue("q_name")
    end
    
    def test_deletes_message
      Queueue::QS.expects(:delete_message).with('q_name', 'msg_id')
      Adapter.delete_message("q_name", "msg_id")
    end
    
    def test_sends_message
      Queueue::QS.expects(:send_message).with('q_name', 'rock')
      Adapter.send_message("q_name", "rock")
    end
    
    def test_sets_queue_visibility_timeout
      Queueue::QS.expects(:set_visibility_timeout).with('q_name', 5)
      Adapter.set_visibility_timeout("q_name", 5)
    end
  end
end