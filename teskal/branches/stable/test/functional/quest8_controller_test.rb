require File.dirname(__FILE__) + '/../test_helper'
require 'quest8_controller'

# Re-raise errors caught by the controller.
class Quest8Controller; def rescue_action(e) raise e end; end

class Quest8ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Test8Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
