require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
        name: 'Test User', 
        email: 'test@test.com', 
        password: 'test123', 
        password_confirmation: 'test123'
      )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'name not too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email not too long' do
    @user.email = 'a' * 250 + '@test.com'
    assert_not @user.valid?
  end

  test 'accepts valid emails' do
    valid_emails = %w[user@example.com USER@foo.COM a_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_emails.each {|email|
      @user.email = email
      assert @user.valid?, "#{email.inspect} should be valid"}
  end

  test 'rejects invalid emails' do
    valid_emails = %w[user@example,com USER-at-foo.COM a_US-ER@foo@bar.org first@last_foo.jp alice@bob+baz.cn]
    valid_emails.each {|email|
      @user.email = email
      assert_not @user.valid?, "#{email.inspect} should be invalid"}
  end

  test 'email uniqueness' do
    dup_user = @user.dup
    @user.save
    assert_not dup_user.valid?
  end

  test 'emails saved lowercase' do
    mixed_email = 'mIxEdCaSe@TeSt.CoM'
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test 'password exists' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end
