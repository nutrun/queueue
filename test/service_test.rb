require "test/unit"
require File.dirname(__FILE__) + "/../lib/queueue"

module Queueue
  class ServiceTest < Test::Unit::TestCase
    def teardown
      QS.send :reset!
    end

    def test_creates_queue
      QS.create_queue 'name'
      assert_equal 1, QS.list_queues.size
    end
    
    def test_returns_queue_on_queue_creation
      q = QS.create_queue 'name'
      assert_equal 'name', q.name
    end
    
    def test_deletes_queue
      QS.create_queue 'name'
      assert_equal 1, QS.list_queues.size
      QS.delete_queue 'name'
      assert_equal 0, QS.list_queues.size
    end
    
    def test_sends_message_to_queue
      QS.create_queue 'name'
      QS.send_message 'name', 'message_body'
      assert_equal 1, QS.list_queues[0].messages.size
    end
    
    def test_sets_queue_visibility_timeout_on_new_message
      QS.create_queue 'name'
      QS.send_message 'name', 'message_body'
      assert_equal 30, QS.list_queues[0].messages[0].visibility_timeout
    end
    
    def test_returns_message_id_on_creation
      QS.create_queue 'name'
      msg_id = QS.send_message 'name', 'message body'
      assert /(.){20}\|(.){20}\|(.){20}/ =~ msg_id
    end
    
    def test_peeks_message
      QS.create_queue 'name'
      msg_id = QS.send_message 'name', 'message body'
      msg = QS.peek_message 'name', msg_id
      assert_equal 'message body', msg.body
    end
    
    def test_deletes_message
      QS.create_queue 'name'
      msg_id = QS.send_message 'name', 'message body'
      QS.delete_message 'name', msg_id
      assert_equal 0, QS.list_queues[0].messages.size
    end

    def test_lists_single_queued_message_if_no_number_of_messages_specified
      QS.create_queue 'name'
      QS.send_message 'name', 'first message body'
      QS.send_message 'name', 'second message body'
      messages = QS.receive_message 'name', nil, nil
      assert_equal 1, messages.size
      assert_equal 'first message body', messages[0].body
    end

    def test_lists_specified_number_of_queued_messages
      QS.create_queue 'name'
      QS.send_message 'name', 'first message body'
      QS.send_message 'name', 'second message body'
      QS.send_message 'name', 'third message body'
      messages = QS.receive_message 'name', 2, nil
      assert_equal 2, messages.size
      assert_equal 'first message body', messages[0].body
      assert_equal 'second message body', messages[1].body
    end

    def test_lists_all_messages_if_number_of_queued_messages_is_less_than_specified
      QS.create_queue 'name'
      QS.send_message 'name', 'first message body'
      QS.send_message 'name', 'second message body'
      messages = QS.receive_message 'name', 5, nil
      assert_equal 2, messages.size
    end

    def test_30_seconds_default_visibility_timeout
      assert_equal 30, Queue.new('name').visibility_timeout
    end

    def test_sets_visibility_timeout_on_queue
      QS.create_queue 'name'
      QS.set_visibility_timeout 'name', 60
      assert_equal 60, QS.list_queues[0].visibility_timeout
    end

    def test_gets_queue_visibility_timeout
      QS.create_queue 'name'
      assert_equal 30, QS.get_visibility_timeout('name')
    end

    def test_sets_visibility_timeout_on_receive_message
      QS.create_queue 'name'
      3.times {QS.send_message 'name', 'message body'}
      QS.receive_message('name', 3, 50).each do |message| 
        assert_equal 50, message.visibility_timeout
      end
    end

    def test_message_is_not_visible_if_locked_for_visibility_timeout
      QS.create_queue 'name'
      QS.send_message 'name', 'message body'
      assert_equal 1, QS.receive_message('name', nil, nil).size
      assert_equal 0, QS.receive_message('name', nil, nil).size
    end

    def test_gets_subsequent_messages_after_locked_ones
      QS.create_queue 'name'
      QS.send_message 'name', '1'
      QS.send_message 'name', '2'
      assert_equal '1', QS.receive_message('name', nil, nil)[0].body
      assert_equal '2', QS.receive_message('name', nil, nil)[0].body
    end

    def test_raises_invalid_parameter_value_for_name_queue_name_length
      assert_raise(InvalidParameterValue) {QS.create_queue 'a'*81}
    end

    def test_raises_non_empty_queue_if_queue_non_empty_on_delete
      QS.create_queue 'name'
      QS.send_message 'name', 'body'
      assert_raise(NonEmptyQueue) {QS.delete_queue 'name'}
    end

    def test_raises_non_existent_queue_if_queue_doesnt_exist_on_delete
      assert_raise(NonExistentQueue) {QS.delete_queue 'name'}
    end

    def test_raises_missing_parameter_if_no_message_supplied_on_send_message
      QS.create_queue 'name'
      assert_raise(MissingParameter) {QS.send_message 'name', nil}
    end

    def test_raises_non_existent_queue_if_queue_doesnt_exist_on_send_message
      assert_raise(NonExistentQueue) {QS.send_message 'name', 'body'}
    end

    def test_raises_non_existent_queue_if_queue_doesnt_exist_on_set_visibility_timeout
      assert_raise(NonExistentQueue) {QS.set_visibility_timeout 'name', 60}
    end

    def test_raises_invalid_parameter_value_when_visibility_timeout_out_of_range
      QS.create_queue 'name'
      assert_raise(InvalidParameterValue) {QS.set_visibility_timeout 'name', 86401}
      assert_raise(InvalidParameterValue) {QS.receive_message 'name', nil, 86401}
    end

    def test_raises_invalid_parameter_value_when_number_of_messages_out_of_range
      QS.create_queue 'name'
      assert_raise(InvalidParameterValue) {QS.receive_message 'name', 257, nil}
    end

    def test_raises_missing_parameter_if_message_id_nil
      QS.create_queue 'name'
      assert_raise(MissingParameter) {QS.peek_message 'name', nil}
    end

    def test_raises_message_not_found_if_no_message_exists
      QS.create_queue 'name'
      assert_raise(MessageNotFound) {QS.peek_message 'name', 'msg_id'}
    end

    def test_raises_invalid_parameter_value_for_nil_queue_name_on_create
      assert_raise(InvalidParameterValue) {QS.create_queue nil}
    end

    def test_raises_invalid_parameter_value_for_blank_queueue_name_on_create
      assert_raise(InvalidParameterValue) {QS.create_queue ''}
    end

    def test_find_queue_with_queue_name_prefix
      QS.create_queue 'sabbath'
      QS.create_queue 'zztop'
      queues = QS.list_queues 'zz'
      assert_equal 1, queues.size
      assert_equal 'zztop', queues[0].name
    end
  end  
end
