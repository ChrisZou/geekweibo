class TweetBlueprint < Blueprinter::Base
  identifier :id
  field :body

  association :user, blueprint: UserBlueprint
  association :comments, blueprint: CommentBlueprint
end
