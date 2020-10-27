class CommentBlueprint < Blueprinter::Base
  identifier :id
  field :body
  association :user, blueprint: UserBlueprint
  association :parent_comment, blueprint: CommentBlueprint
end
