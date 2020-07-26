class TagsController < ApplicationController
  def show
    @tag = params[:id]
    @tweets = Tweet.with_tag(@tag).includes({user: {avatar_attachment: [:blob]}}, :likes).order(created_at: :desc)
  end
end
