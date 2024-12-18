require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bob)
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
  end

end
