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
  has_many :comments, dependent: :destroy

  scope :with_tag, -> (tag) { where("body ilike ?", "%##{tag}%") }

  searchkick word_middle: [:body]

  def liked
    return false unless Current.user
    likes.any? { _1.user_id == Current.user.id }
  end

  def like_count
    likes.count
  end

end
