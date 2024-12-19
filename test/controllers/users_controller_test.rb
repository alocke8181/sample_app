require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
    @other_user = users(:paul)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test 'redirects edit for no login' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'redirects update for no login' do
    patch user_path(@user), params:{
      user:{
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'redirects edit for wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'redirects update for wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params:{
      user:{
        name: @user.name,
        email: @user.email
      }
    }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'index redirects for no login' do
    get users_path
    assert_redirected_to login_url
  end

  test 'destroy redirects for no login' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'destroy redirects for no admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test 'redirects following no login' do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test 'redirects followers no login' do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
