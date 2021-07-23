require "test_helper"

class DemoControllerTest < ActionDispatch::IntegrationTest
  test "should get cache" do
    get demo_cache_url
    assert_response :success
  end
end
