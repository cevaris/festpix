require 'test_helper'

class PhotoSessionsControllerTest < ActionController::TestCase
  setup do
    @photo_session = photo_sessions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:photo_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photo_session" do
    assert_difference('PhotoSession.count') do
      post :create, photo_session: { event_id: @photo_session.event_id, name: @photo_session.name, photo_user_id: @photo_session.photo_user_id }
    end

    assert_redirected_to photo_session_path(assigns(:photo_session))
  end

  test "should show photo_session" do
    get :show, id: @photo_session
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @photo_session
    assert_response :success
  end

  test "should update photo_session" do
    patch :update, id: @photo_session, photo_session: { event_id: @photo_session.event_id, name: @photo_session.name, photo_user_id: @photo_session.photo_user_id }
    assert_redirected_to photo_session_path(assigns(:photo_session))
  end

  test "should destroy photo_session" do
    assert_difference('PhotoSession.count', -1) do
      delete :destroy, id: @photo_session
    end

    assert_redirected_to photo_sessions_path
  end
end
