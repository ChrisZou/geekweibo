class LikesController < ApplicationController

  # POST /likes
  # POST /likes.json
  def create
    p = like_params
    p[:user_id] = current_user.id
    @like = Like.new(p)

    if @like.save
      render :show, status: :created, location: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    Like.where(user_id: current_user.id, likable_id: like_params[:likable_id]).destroy_all
  end

  private
    # Only allow a list of trusted parameters through.
    def like_params
      params.require(:like).permit(:user_id, :likable_id, :likable_type)
    end
end
