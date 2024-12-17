require "test_helper"

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:first)
  end

  test 'redirect create on no login' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {micropost: {content: "no login = no posting!"}}
    end
    assert_redirected_to login_url
  end

  test 'redirect destroy on no login' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end
end
