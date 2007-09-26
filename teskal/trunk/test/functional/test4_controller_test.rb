require File.dirname(__FILE__) + '/../test_helper'
require 'test4_controller'

# Re-raise errors caught by the controller.
class Test4Controller; def rescue_action(e) raise e end; end

class Test4ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Test4Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
