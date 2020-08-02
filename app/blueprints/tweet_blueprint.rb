class TweetBlueprint < Blueprinter::Base
  identifier :id
  fields :body, :liked, :like_count

  association :user, blueprint: UserBlueprint
  association :comments, blueprint: CommentBlueprint do |tweet|
    tweet.comments.order(created_at: :desc)
  end
end
