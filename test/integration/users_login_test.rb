require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bob)
  end

  test 'valid login' do
    get login_path
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    #What if a user closes it in another window too?!
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test 'invalid login' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: ' ', password: ' '} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_not is_logged_in?
    get root_path
    assert flash.empty?
  end

  test 'remembering test' do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies[:remember_token]
  end

  test 'not remembering test' do
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    assert_nil cookies[:remember_token]
  end
end
