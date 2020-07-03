class TagsController < ApplicationController
  def show
    @tweets = Tweet.with_tag(params[:id]).includes([:user]).all
  end
end
