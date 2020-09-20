require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get agreement" do
    get welcome_agreement_url
    assert_response :success
  end

end
