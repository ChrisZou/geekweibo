# == Schema Information
#
# Table name: tweets
#
#  id      :uuid             not null, primary key
#  body    :text
#  user_id :uuid             not null
#
class Tweet < ApplicationRecord
  belongs_to :user

  validates :body, presence: true, length: { minimum: 1 }

  searchkick word_middle: [:body]
end
