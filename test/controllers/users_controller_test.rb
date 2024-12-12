require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
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
end
