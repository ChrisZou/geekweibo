class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :setup_current_user

  def setup_current_user
    Current.user = current_user
  end

  def current_user_json
    UserBlueprint.render(current_user)
  end
  helper_method :current_user_json

  def sanitize(text) 
    Loofah.fragment(text).to_text
  end
end
