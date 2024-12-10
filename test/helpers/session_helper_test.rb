require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
    def setup
        @user = users(:bob)
        remember(@user)
    end

    test 'returns correctly for nil session' do
        assert_equal @user, current_user
        assert is_logged_in?
    end

    test 'returns nil for wrong digest' do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        assert_nil current_user
    end
end