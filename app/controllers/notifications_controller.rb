class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.includes(:actor).order(created_at: :desc).take(10)
    render json: NotificationBlueprint.render(@notifications)
  end

  def mark_read
    current_user.notifications.unread.update_all(read_at: DateTime.now)
    render json: {}
  end
end
