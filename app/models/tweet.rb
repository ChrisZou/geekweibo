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

  scope :with_tag, -> (tag) { where("body ilike ?", "%##{tag}%") }
  attr_accessor :current_user

  searchkick word_middle: [:body]

  def liked
    return false unless @current_user
    likes.map { _1.user_id }.include? @current_user.id
  end

  def like_count
    likes.count
  end

end
