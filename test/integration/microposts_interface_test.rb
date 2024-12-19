require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob)
  end

  test 'microposts' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: ''}}
    end
    
    assert_select 'a[href=?]', '/?page=2'

    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: {content: 'Valid post'}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match 'Valid post', response.body

    assert_select 'button', text: 'Delete'
    first_micropost = @user.microposts.paginate(page:1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    get user_path(users(:paul))
    assert_select 'button', text: 'Delete', count: 0
  end
end
