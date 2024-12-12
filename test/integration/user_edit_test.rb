require "test_helper"

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test 'bad edit' do
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
end
