require File.dirname(__FILE__) + '/../test_helper'

class BooksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:books)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_book
    assert_difference('Book.count') do
      post :create, :book => { }
    end

    assert_redirected_to book_path(assigns(:book))
  end

  def test_should_show_book
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_book
    put :update, :id => 1, :book => { }
    assert_redirected_to book_path(assigns(:book))
  end

  def test_should_destroy_book
    assert_difference('Book.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to books_path
  end
end
