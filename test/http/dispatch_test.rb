require File.dirname(__FILE__) + "/test_helper"

class DispatchTest < Test::Unit::TestCase
  def setup
    validator = Queueue::Http::RequestValidator.new({})
    Queueue::Http::RequestValidator.stubs(:new).returns(validator)
    validator.stubs(:date_valid?).returns(true)
    validator.stubs(:authorized?).returns(true)
    @adapter = Queueue::Http::Adapter
  end
  
  def test_creates_queue
    @adapter.expects(:create_queue).with("rock")
    post_it "/", "QueueName" => "rock"
  end
  
  def test_lists_queues
    @adapter.expects(:list_queues).with(nil)
    get_it "/"
  end
  
  def test_lists_queues_with_prefix
    @adapter.expects(:list_queues).with("prefix")
    get_it "/", "QueueNamePrefix" => "prefix"
  end
  
  def test_gets_visibility_timeout
    @adapter.expects(:get_visibility_timeout).with("q_name")
    get_it "/prefix/q_name"
  end
  
  def test_receives_message
    @adapter.expects(:receive_message).with('q_name', nil, nil)
    get_it "/prefix/q_name/front"
  end
  
  def test_receives_max_number_of_messages
    @adapter.expects(:receive_message).with('q_name', 5, nil)
    get_it "/prefix/q_name/front", "NumberOfMessages" => '5'
  end
  
  def test_receives_messages_setting_visibility_timeout
    @adapter.expects(:receive_message).with('q_name', 1, 5)
    get_it "/prefix/q_name/front", "NumberOfMessages" => "1", "VisibilityTimeout" => '5'
  end
  
  def test_peeks_message
    @adapter.expects(:peek_message).with("q_name", "msg_id")
    get_it "/prefix/q_name/msg_id"
  end
  
  def test_deletes_queue
    @adapter.expects(:delete_queue).with('q_name')
    delete_it "/prefix/q_name"
  end
  
  def test_deletes_message
    @adapter.expects(:delete_message).with('q_name', 'msg_id')
    delete_it "/prefix/q_name/msg_id"
  end
  
  def test_sends_message
    @adapter.expects(:send_message).with('q_name', 'rock')
    put_it "/prefix/q_name/back", "<Message>rock</Message>" => ""
  end
  
  def test_sets_queue_visibility_timeout
    @adapter.expects(:set_visibility_timeout).with('q_name', 5)
    put_it "/prefix/q_name", "VisibilityTimeout" => '5'
  end  
end