require 'test_helper'

class TagControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get tag_show_url
    assert_response :success
  end

end
