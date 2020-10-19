class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:destroy]
  before_action :authorize!, only: [:destroy]

  # POST /comments
  # POST /comments.json
  def create
    cp = comment_params
    @comment = current_user.comments.new(cp)

    if @comment.save
      create_comment_notification(cp)
      render json: CommentBlueprint.render(@comment), status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:tweet_id, :body)
    end

    def authorize!
      if @comment.user.id != current_user.id
        render plain: "forbidden", status: 401
      end
    end

    def create_comment_notification(comment_params)
      tweet = Tweet.find(comment_params[:tweet_id])
      Notification.create(recipient: tweet.user, actor: current_user, action: 'comment', notifiable: tweet)
    end

end
