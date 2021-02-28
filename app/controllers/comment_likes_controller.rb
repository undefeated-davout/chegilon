class CommentLikesController < ApplicationController
  before_action :logged_in_user
  before_action :get_comment, only: [:create, :destroy]

  def create
    current_user.comment_like(@comment)
    respond_to do |format|
      format.html {redirect_to @comment.item}
      format.js
    end
  end

  def destroy
    current_user.comment_unlike(@comment)
    respond_to do |format|
      format.html {redirect_to @comment.item}
      format.js
    end
  end


  private

  def get_comment
    @comment = Comment.find(params[:comment_id])
  end
end
