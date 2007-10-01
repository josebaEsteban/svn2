require File.dirname(__FILE__) + '/../test_helper'
require 'quest7_controller'

# Re-raise errors caught by the controller.
class Quest7Controller; def rescue_action(e) raise e end; end

class Quest7ControllerTest < Test::Unit::TestCase
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
