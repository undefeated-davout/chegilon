class CommentsController < ApplicationController
  before_action :get_comment, only: [:destroy, :liking_users]
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      flash[:success] = "コメントの投稿に成功しました。"
      redirect_to item_path(@comment.item_id)
    else
      @feed_items = []
      flash[:danger] = "コメントの投稿に失敗しました。"
      @item = Item.find(@comment.item_id)
      @comments = @item.comments.page(params[:page])
      render template: "items/show"
    end
  end

  # def edit
  # end
  #
  # def update
  #   if @comment.update_attributes(comment_params)
  #     flash[:success] = "コメントの編集に成功しました。"
  #     redirect_to item_path(@comment.item_id)
  #   else
  #     @feed_items = []
  #     flash[:danger] = "コメントの編集に失敗しました。"
  #     @item = Item.find(@comment.item_id)
  #     @comments = @item.comments.page(params[:page])
  #     render template: "items/show"
  #   end
  # end

  def destroy
    @comment.destroy
    flash[:success] = "コメントを削除しました。"
    redirect_to request.referrer || root_url
  end

  def liking_users
    @users = @comment.comment_liking_users.reorder('comment_likes.updated_at DESC').page(params[:page])
  end


  private

  def comment_params
    params.require(:comment).permit(:item_id, :content, :image)
  end

  def get_comment
    @comment = Comment.find(params[:id])
  end

  def correct_user
    redirect_to root_url if @comment.nil?
  end
end
