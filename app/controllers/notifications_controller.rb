class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = current_user.notifications.includes(:actor)
    render json: NotificationBlueprint.render(@notifications)
  end
end
