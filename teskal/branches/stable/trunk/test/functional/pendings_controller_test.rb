require File.dirname(__FILE__) + '/../test_helper'
require 'pendings_controller'

# Re-raise errors caught by the controller.
class PendingsController; def rescue_action(e) raise e end; end

class PendingsControllerTest < Test::Unit::TestCase
  fixtures :pendings

  def setup
    @controller = PendingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = pendings(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:pendings)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:pending)
    assert assigns(:pending).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:pending)
  end

  def test_create
    num_pendings = Pending.count

    post :create, :pending => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_pendings + 1, Pending.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:pending)
    assert assigns(:pending).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Pending.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Pending.find(@first_id)
    }
  end
end
