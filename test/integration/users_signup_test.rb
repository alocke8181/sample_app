require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'does not create user on invalid signup' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: ' ',
          email: 'invalid@test.com',
          password: 'test',
          password_confirmation: 'fail'
        }
      }
    end
    assert_template 'users/new'
  end

  test 'valid signup and activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: 'Valid User',
          email: 'valid@test.com',
          password: 'validpassword',
          password_confirmation: 'validpassword'
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path('wrong token', email: user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong@email.com')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
