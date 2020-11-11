class TweetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tweet, only: [:edit, :update, :destroy]
  before_action :authorize!, only: [:edit, :update, :destroy]

  # GET /tweets
  # GET /tweets.json
  def index
    query = params[:q]
    respond_to do |format|
      format.html { 
        if query
          @tweets_url = "/tweets.json?q=#{query}"
        else
          @tweets_url = "/tweets.json" 
        end
      }
      format.json { 
        tweets, has_more = if query
          search_result = Tweet.search(query, 
                                       page: params[:page] || 1, 
                                       per_page: 20, 
                                       includes: [
                                         {user: {avatar_attachment: [:blob]}},
                                         :likes, {images_attachments: [:blob]},
                                         {comments: {user: {avatar_attachment: [:blob]}}}
                                       ])
          [search_result.results, search_result.current_page < search_result.total_pages]
        else
          @pagy, tweets = pagy Tweet.includes({user: {avatar_attachment: [:blob]}},
                                              :likes, 
                                              {images_attachments: [:blob]},
                                              {comments: {user: {avatar_attachment: [:blob]}}}).order(created_at: :desc)
          [tweets, @pagy.page < @pagy.pages]
        end
        render json: {has_more: has_more, data: TweetBlueprint.render_as_hash(tweets) }
      }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @tweet = Tweet.includes({user: {avatar_attachment: [:blob]}}, :likes, {comments: [{user: {avatar_attachment: [:blob]}}, :parent_comment]}).find(params[:id])
    @tweet_json = TweetBlueprint.render(@tweet)
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = current_user.tweets.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { render json: TweetBlueprint.render(@tweet), status: :created }
        format.json { render json: TweetBlueprint.render(@tweet), status: :created }
      else
        format.html { render :new }
        format.json { render json: { result: 'error', error: @tweet.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:body, images: [])
    end

    def authorize!
      if @tweet.user.id != current_user.id
        render plain: "forbidden", status: 401
      end
    end

end
