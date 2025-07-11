require "test_helper"

class SharedWishlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get shared_wishlists_create_url
    assert_response :success
  end

  test "should get destroy" do
    get shared_wishlists_destroy_url
    assert_response :success
  end
end
