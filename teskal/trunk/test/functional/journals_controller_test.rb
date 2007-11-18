require File.dirname(__FILE__) + '/../test_helper'
require 'journals_controller'

# Re-raise errors caught by the controller.
class JournalsController; def rescue_action(e) raise e end; end

class JournalsControllerTest < Test::Unit::TestCase
  fixtures :journals

  def setup
    @controller = JournalsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:journals)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_journal
    old_count = Journal.count
    post :create, :journal => { }
    assert_equal old_count+1, Journal.count
    
    assert_redirected_to journal_path(assigns(:journal))
  end

  def test_should_show_journal
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_journal
    put :update, :id => 1, :journal => { }
    assert_redirected_to journal_path(assigns(:journal))
  end
  
  def test_should_destroy_journal
    old_count = Journal.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Journal.count
    
    assert_redirected_to journals_path
  end
end
