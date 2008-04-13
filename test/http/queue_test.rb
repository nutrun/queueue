require File.dirname(__FILE__) + "/test_helper"

module Queueue
  class QueueTest < Test::Unit::TestCase
    def test_url
      queue = Queue.new 'rock'
      assert_equal 'http://127.0.0.1:2323/A23E9WXPHGOG29/rock', queue.url
    end
  end
end
