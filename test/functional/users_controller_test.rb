require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:general)
    activate_authlogic
  end

  #################### New
  test "should get new" do
    get :new
    assert_template :new
  end

  test "should NOT get new by user" do
    assert UserSession.create(@user)
    get :new
    assert_redirected_to user_path(@user)
  end
  #################### New



  #################### Create
  test "should create user" do
    assert_difference('User.count') do
      post :create, user: 
        {login: 'new_user', password: 'password', password_confirmation: 'password'}
    end
    assert_redirected_to user_path(assigns(:user))
  end

  test "should NOT create user by user" do
    assert UserSession.create(@user)
    assert_no_difference('User.count') do
      post :create, user: 
        {login: 'new_user', password: 'password', password_confirmation: 'password'}
    end
    assert_redirected_to user_path(@user)
  end
  #################### Create



  #################### Show
  test "should show user" do
    assert UserSession.create(@user)
    get :show, id: @user.id.to_s
    assert_template :show
    assert_equal @user, assigns(:user)
  end

  test "should NOT show user by not user" do
    get :show, id: @user.id.to_s
    assert_redirected_to controller: :user_sessions, action: :new
  end
  #################### Show



  #################### Edit
  test "should get edit" do
    assert UserSession.create(@user)
    get :edit, id: @user.id.to_s
    assert_response :success
    assert_template :edit
    assert_equal @user, assigns(:user)
  end

  test "should NOT get edit by not user" do
    get :edit, id: @user.id.to_s
    assert_redirected_to controller: :user_sessions, action: :new
  end
  #################### Edit



  #################### Update
  test "should update user" do
    assert UserSession.create(@user)
    put :update, id: @user.id.to_s, user: {login: @user.login}
    assert_redirected_to user_path(assigns(:user))
  end

  test "should NOT update by not user" do
    put :update, id: @user.id.to_s, user: {login: @user.login}
    assert_redirected_to controller: :user_sessions, action: :new
  end
  #################### Update
end
