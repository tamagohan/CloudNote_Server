require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
setup :activate_authlogic

  test "should login" do
    user = users(:general)
    put :create, user_session: {login: user.login, password: 'benrocks'}
    assert_redirected_to user_path(user)
  end

  test "should NOT login" do
    user = users(:general)
    put :create, user_session: {login: user.login, password: 'invalid_password'}
    assert_template :new
  end

  test "should logout" do
    user = users(:general)
    assert UserSession.create(user)
    delete :destroy, id: user.id
    assert_redirected_to new_user_session_url
    assert_nil session["user_credentials"]
    assert_nil session["user_credentials_id"]
  end
end
