class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  belongs_to :parent_comment, class_name: 'Comment'
  has_many :subcomments, class_name: 'Comment', foreign_key: 'parent_comment_id'
end
