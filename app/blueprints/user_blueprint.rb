class UserBlueprint < Blueprinter::Base
  fields :nickname, :id
  field :avatar_url, name: :avatar
end
