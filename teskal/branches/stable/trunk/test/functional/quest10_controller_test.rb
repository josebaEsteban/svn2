require File.dirname(__FILE__) + '/../test_helper'
require 'quest10_controller'

# Re-raise errors caught by the controller.
class Quest10Controller; def rescue_action(e) raise e end; end

class Quest10ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Quest10Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
