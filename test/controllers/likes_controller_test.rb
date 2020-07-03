require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @like = likes(:one)
  end

  test "should get index" do
    get likes_url, as: :json
    assert_response :success
  end

  test "should create like" do
    assert_difference('Like.count') do
      post likes_url, params: { like: { likable_id: @like.likable_id, likable_type: @like.likable_type, user_id: @like.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show like" do
    get like_url(@like), as: :json
    assert_response :success
  end

  test "should update like" do
    patch like_url(@like), params: { like: { likable_id: @like.likable_id, likable_type: @like.likable_type, user_id: @like.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy like" do
    assert_difference('Like.count', -1) do
      delete like_url(@like), as: :json
    end

    assert_response 204
  end
end
