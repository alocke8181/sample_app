require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:bob)
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    #Bad email
    post password_resets_path, params: {password_reset: {email: ''}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #Good email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    #Form
    user = assigns(:user)
    #bad email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    #inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #good email, bad token
    get edit_password_reset_path('this is the wrong token!', email: user.email)
    assert_redirected_to root_url
    #good email & token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    #bad password and confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'foobar',
        password_confirmation: 'barfoo'
      }
    }
    #blank form
    patch password_reset_path(user.reset_token), params: {
      email: user.email, user: {password: '' , password_confirmation: ''}
    }
    #good form
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'newpassword',
        password_confirmation: 'newpassword'
      }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
