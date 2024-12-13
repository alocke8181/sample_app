require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test 'index with pagination' do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page:1).per_page(10).each do |u|
      assert_select "a[href=?]", user_path(u), text: u.name
    end
  end
end
