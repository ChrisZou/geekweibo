class LikesController < ApplicationController

  before_action :authenticate_user!

  # POST /likes
  # POST /likes.json
  def create
    @like = current_user.likes.new(like_params)
    if @like.save
      render json: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    current_user.likes.where(likable_id: like_params[:likable_id]).destroy_all
  end

  private
    # Only allow a list of trusted parameters through.
    def like_params
      params.require(:like).permit(:user_id, :likable_id, :likable_type)
    end
end
