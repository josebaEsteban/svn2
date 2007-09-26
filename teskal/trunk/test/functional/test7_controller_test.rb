require File.dirname(__FILE__) + '/../test_helper'
require 'test7_controller'

# Re-raise errors caught by the controller.
class Test7Controller; def rescue_action(e) raise e end; end

class Test7ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Test7Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
