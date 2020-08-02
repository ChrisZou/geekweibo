class CommentBlueprint < Blueprinter::Base
  identifier :id
  field :body
  association :user, blueprint: UserBlueprint
end
