class ApplicationController < ActionController::Base
  include Pagy::Backend
  skip_before_action :verify_authenticity_token, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :setup_current_user

  def setup_current_user
    Current.user = current_user
  end

  def current_user_json
    UserBlueprint.render(current_user)
  end
  helper_method :current_user_json
end
