require "test_helper"

class Admin::ImageUploadsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get admin_image_uploads_create_url
    assert_response :success
  end
end
