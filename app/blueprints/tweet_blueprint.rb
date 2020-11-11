class TweetBlueprint < Blueprinter::Base
  identifier :id

  fields :body, :liked, :like_count

  field :image do |tweet, options|
    tweet.images.first&.service_url
  end

  association :user, blueprint: UserBlueprint
  association :comments, blueprint: CommentBlueprint do |tweet|
    tweet.comments
  end
end
