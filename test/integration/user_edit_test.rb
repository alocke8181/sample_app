require "test_helper"

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test 'bad edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: '',
        email: 'bad@email',
        password: 'not',
        password_confirmation: 'matching'
      }
    }
    assert_template 'users/edit'
  end

  test 'good edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Paul'
    email = 'new_email@test.com'
    patch user_path(@user), params:{
      user:{
        name: name,
        email: email,
        password: 'password',
        password_confirmation: 'password'
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
