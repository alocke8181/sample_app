require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:bob)
    @user = users(:paul)
  end

  test 'index with pagination and admin' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page:1).per_page(10).each do |u|
      assert_select "a[href=?]", user_path(u), text: u.name
      unless u == @admin
        assert_select 'button', text: 'Delete'
      end
    end
  end

  test 'index without admin' do
    log_in_as(@user)
    get users_path
    assert_select 'button', text: 'Delete', count: 0
  end

end
