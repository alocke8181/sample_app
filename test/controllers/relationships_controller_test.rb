require "test_helper"

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test 'create requires login' do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test 'delete requires login' do
    assert_no_difference 'Relationship.count' do
      delete relationships_path
    end
    assert_redirected_to login_url
  end
end
