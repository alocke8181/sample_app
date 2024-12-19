require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = Relationship.new(follower_id: users(:bob).id, followed_id: users(:paul).id)
  end

  test 'valid' do
    assert @relationship.valid?
  end

  test 'require follower id' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'require followed id' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
