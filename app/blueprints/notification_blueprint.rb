class NotificationBlueprint < Blueprinter::Base
  identifier :id
  fields :created_at, :notifiable_type, :notifiable_id, :action, :read_at

  association :actor, blueprint: UserBlueprint
end
