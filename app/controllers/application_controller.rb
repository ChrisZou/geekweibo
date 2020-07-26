class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :setup_current_user

  def setup_current_user
    Current.user = current_user
  end
end
