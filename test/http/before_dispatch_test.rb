require File.dirname(__FILE__) + "/test_helper"

class BeforeDispatchTest < Test::Unit::TestCase
  def setup
    @validator = Queueue::Http::RequestValidator.new({})
    Queueue::Http::RequestValidator.stubs(:new).returns(@validator)
  end
  
  def test_halts_on_invalid_date
    @validator.expects(:date_valid?).returns(false)
    @validator.stubs(:invalid_date).returns("error")
    get_it "/"
    assert_equal("error", body)
  end
  
  def test_halts_on_failed_auth
    @validator.stubs(:date_valid?).returns(true)
    @validator.expects(:authorized?).returns(false)
    @validator.stubs(:auth_failure).returns("error")
    get_it "/"
    assert_equal("error", body)
  end
end