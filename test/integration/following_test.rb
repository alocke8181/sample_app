require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @bob = users(:bob)
    @paul = users(:paul)
    log_in_as(@bob)
  end

  test 'following page' do
    get following_user_path(@bob)
    assert_not @bob.following.empty?
    assert_match @bob.following.count.to_s, response.body
    @bob.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'followers page' do
    get followers_user_path(@bob)
    assert_not @bob.followers.empty?
    assert_match @bob.followers.count.to_s, response.body
    @bob.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end

  test 'standard following' do
    assert_difference '@bob.following.count', 1 do
      post relationships_path, params: {followed_id: @paul.id}
    end
  end

  test 'ajax following' do
    assert_difference '@bob.following.count', 1 do
      post relationships_path, xhr: true, params: {followed_id: @paul.id}
    end
  end

  test 'standard unfollowing' do
    @bob.follow(@paul)
    relationship = @bob.active_relationships.find_by(followed_id: @paul.id)
    assert_difference '@bob.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'ajax unfollowing' do
    @bob.follow(@paul)
    relationship = @bob.active_relationships.find_by(followed_id: @paul.id)
    assert_difference '@bob.following.count', -1 do
      delete relationship_path(relationship)
    end
  end
end
