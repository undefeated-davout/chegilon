class TagFollowsController < ApplicationController
  before_action :logged_in_user
  before_action :get_tag, only: [:create, :destroy]

  def create
    current_user.tag_follow(@tag)
    respond_to do |format|
      format.html {redirect_to tags_path}
      format.js
    end
  end

  def destroy
    current_user.tag_unfollow(@tag)
    respond_to do |format|
      format.html {redirect_to tags_path}
      format.js
    end
  end


  private

  def get_tag
    @tag = Tag.find(params[:tag_id])
  end
end
