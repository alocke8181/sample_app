require "test_helper"

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:bob)
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
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

end
