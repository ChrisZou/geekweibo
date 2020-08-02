class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  # GET /users/1
  # GET /users/1.json
  def show
    tweets = @user.tweets.includes({user: {avatar_attachment: [:blob]}}, :likes, {comments: {user: {avatar_attachment: [:blob]}}}).order(created_at: :desc)
    @tweets_json = TweetBlueprint.render(tweets)
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname, :phone, :password_digest, :bio, :avatar)
  end
end
