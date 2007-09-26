require File.dirname(__FILE__) + '/../test_helper'
require 'test1_controller'

# Re-raise errors caught by the controller.
class Test1Controller; def rescue_action(e) raise e end; end

class Test1ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Test1Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
