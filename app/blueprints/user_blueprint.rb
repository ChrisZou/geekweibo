class UserBlueprint < Blueprinter::Base
  identifier :id
  fields :nickname
  field :avatar_url, name: :avatar
end
