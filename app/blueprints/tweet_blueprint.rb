class TweetBlueprint < Blueprinter::Base
  identifier :id

  fields :body, :liked, :like_count
  field :created_at, datetime_format: -> { _1.today? ?  _1.strftime('%H:%M') : _1.strftime('%m-%d %H:%M') }

  association :user, blueprint: UserBlueprint
  association :comments, blueprint: CommentBlueprint do |tweet|
    tweet.comments
  end
end
