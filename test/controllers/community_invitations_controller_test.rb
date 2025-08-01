require "test_helper"

class CommunityInvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get community_invitations_new_url
    assert_response :success
  end

  test "should get create" do
    get community_invitations_create_url
    assert_response :success
  end

  test "should get accept" do
    get community_invitations_accept_url
    assert_response :success
  end

  test "should get decline" do
    get community_invitations_decline_url
    assert_response :success
  end
end
