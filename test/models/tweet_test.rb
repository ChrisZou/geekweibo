# == Schema Information
#
# Table name: tweets
#
#  id      :uuid             not null, primary key
#  body    :text
#  user_id :uuid             not null
#
require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
