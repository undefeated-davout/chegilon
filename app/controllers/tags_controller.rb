class TagsController < ApplicationController
  include TagsHelper

  before_action :get_tag, only: [:destroy, :tag_following_users]

  def index
    tag_cloud
  end

  def tag_following_users
    @users = @tag.tag_following_active_users.page(params[:page])
  end

  private

  def get_tag
    @tag = Tag.find(params[:id])
  end
end
