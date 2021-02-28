class UsersController < ApplicationController
  before_action :get_user, only: [:show, :following, :followers,
                                  :stock_items, :follow_tags, :items, :comments, :contributions]

  def index
    @users = User.where(active: true).page(params[:page])
  end

  def show
    redirect_to root_path unless @user.active
    @tags = @user.tag_following_tags.reorder('tag_follows.updated_at DESC')
  end

  def following
    @title = "フォローしているユーザー"
    @relationship_users = @user.active_following.reorder('relationships.updated_at DESC').page(params[:page])
    render 'show_follow_users'
  end

  def followers
    @title = "フォロワー"
    @relationship_users = @user.active_followers.reorder('relationships.updated_at DESC').page(params[:page])
    render 'show_follow_users'
  end

  def follow_tags
    @tags = @user.tag_following_tags.reorder('tag_follows.updated_at DESC').page(params[:page])
    render 'show_follow_tags'
  end

  def stock_items
    @items = @user.active_item_stocking_items.includes(:update_user).reorder('item_stocks.updated_at DESC').page(params[:page])
    render 'show_stock_items'
  end

  def items
    @items = @user.active_create_items.includes(:update_user).reorder('items.updated_at DESC').page(params[:page])
    render 'show_items'
  end

  def comments
    @comments = @user.comments.includes(:item).reorder('comments.created_at DESC').page(params[:page])
    render 'show_comments'
  end

  def contributions
    @items = @user.stocked_items.page(params[:page])
    @comments = @user.liked_comments.page(params[:page])
    @title = "フォロワー"
    @relationship_users = @user.active_followers.reorder('relationships.updated_at DESC').page(params[:page])
    render 'show_contributions'
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def get_user
    # Finding by id on being able to get user id.
    @user = User.find_by_name(params[:id])
    redirect_to root_path unless @user
  end
end
