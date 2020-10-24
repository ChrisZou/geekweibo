class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update tweets]

  before_action :authorize!, only: [:edit, :update]



  # GET /users/1
  # GET /users/1.json
  def show
    @tweets_url = "/users/#{@user.id}/tweets"
  end

  # GET /users/1/edit
  def edit
  end

  # GET /users/1/tweets
  def tweets
    @pagy, tweets = pagy @user.tweets.includes({user: {avatar_attachment: [:blob]}}, :likes, {comments: {user: {avatar_attachment: [:blob]}}}).order(created_at: :desc)
    render json: {has_more: @pagy.page < @pagy.pages, data: TweetBlueprint.render_as_hash(tweets) }
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    up = user_params
    up[:nickname] = sanitize(up[:nickname])
    up[:bio] = sanitize(up[:bio])
    respond_to do |format|
      if @user.update(up)
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
    params.require(:user).permit(:nickname, :bio, :avatar)
  end

  def authorize!
    if @user.id != current_user.id
      render plain: "forbidden", status: 401
    end
  end

end
