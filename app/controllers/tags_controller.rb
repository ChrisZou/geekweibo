class TagsController < ApplicationController
  def show
    @tag = params[:id]
    user = current_user
    @tweets = Tweet.with_tag(@tag).includes([:user]).all.map { _1.current_user = user; _1 }
  end
end
