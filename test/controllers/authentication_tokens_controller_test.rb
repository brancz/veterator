require 'test_helper'

class AuthenticationTokensControllerTest < ActionController::TestCase
  setup do
    @authentication_token = authentication_tokens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authentication_tokens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create authentication_token" do
    assert_difference('AuthenticationToken.count') do
      post :create, authentication_token: { token: @authentication_token.token, user_id: @authentication_token.user_id, valid_until: @authentication_token.valid_until }
    end

    assert_redirected_to authentication_token_path(assigns(:authentication_token))
  end

  test "should show authentication_token" do
    get :show, id: @authentication_token
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @authentication_token
    assert_response :success
  end

  test "should update authentication_token" do
    patch :update, id: @authentication_token, authentication_token: { token: @authentication_token.token, user_id: @authentication_token.user_id, valid_until: @authentication_token.valid_until }
    assert_redirected_to authentication_token_path(assigns(:authentication_token))
  end

  test "should destroy authentication_token" do
    assert_difference('AuthenticationToken.count', -1) do
      delete :destroy, id: @authentication_token
    end

    assert_redirected_to authentication_tokens_path
  end
end
