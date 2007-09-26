require File.dirname(__FILE__) + '/../test_helper'
require 'test5_controller'

# Re-raise errors caught by the controller.
class Test5Controller; def rescue_action(e) raise e end; end

class Test5ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Test5Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
