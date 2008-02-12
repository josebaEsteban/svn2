require File.dirname(__FILE__) + '/../test_helper'
require 'quest12_controller'

# Re-raise errors caught by the controller.
class Quest12Controller; def rescue_action(e) raise e end; end

class Quest12ControllerTest < Test::Unit::TestCase
  def setup
    @controller = Quest12Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
