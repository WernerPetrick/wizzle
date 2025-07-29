require "test_helper"

class RoadmapItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get roadmap_items_index_url
    assert_response :success
  end
end
