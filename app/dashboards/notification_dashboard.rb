require "administrate/base_dashboard"

class NotificationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    recipient: Field::BelongsTo.with_options(class_name: "User"),
    actor: Field::BelongsTo.with_options(class_name: "User"),
    notifiable: Field::Polymorphic,
    id: Field::String.with_options(searchable: false),
    recipient_id: Field::String.with_options(searchable: false),
    actor_id: Field::String.with_options(searchable: false),
    read_at: Field::DateTime,
    action: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  recipient
  actor
  notifiable
  created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  recipient
  actor
  notifiable
  id
  recipient_id
  actor_id
  read_at
  action
  created_at
  updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  recipient
  actor
  notifiable
  recipient_id
  actor_id
  read_at
  action
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how notifications are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(notification)
  #   "Notification ##{notification.id}"
  # end
end
