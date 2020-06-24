# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  nickname               :string
#  phone                  :string
#  password_digest        :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
