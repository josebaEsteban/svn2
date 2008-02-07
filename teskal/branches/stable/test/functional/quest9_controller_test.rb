require File.dirname(__FILE__) + '/../test_helper'
require 'quest9_controller'

# Re-raise errors caught by the controller.
class Quest9Controller; def rescue_action(e) raise e end; end

class Quest9ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Quest9Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
