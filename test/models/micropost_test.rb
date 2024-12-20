require "test_helper"

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:bob)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test 'valid micropost' do
    assert @micropost.valid?
  end

  test 'user id required' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content is required' do
    @micropost.content = ''
    assert_not @micropost.valid?
  end

  test 'content limited to 140 chars' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test 'order should be recent first' do
    assert_equal microposts(:first), Micropost.first
  end

end
