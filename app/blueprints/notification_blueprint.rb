class NotificationBlueprint < Blueprinter::Base
  identifier :id
  fields :created_at, :notifiable_type, :notifiable_id, :action

  association :actor, blueprint: UserBlueprint
end
