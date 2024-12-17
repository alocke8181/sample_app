require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test 'creates new user on valid signup' do
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
    #follow_redirect!
    #assert_template 'users/show'
  end
end
