# == Schema Information
#
# Table name: tweets
#
#  id      :uuid             not null, primary key
#  body    :text
#  user_id :uuid             not null
#
class Tweet < ApplicationRecord
  validates :body, presence: true, length: { minimum: 1 }

  belongs_to :user
  has_many :likes, as: :likable

  scope :with_tag, -> (tag) { where("body like ?", "%##{tag}%") }

  searchkick word_middle: [:body]
end
