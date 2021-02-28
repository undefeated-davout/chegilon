class UtilityPagesController < ApplicationController
  def top
    if user_signed_in?
      redirect_to home_path
    else
      @feed_items = Item.includes(:update_user).limit(10)
      @feed_comments = Comment.includes([:item, :user]).limit(10)
    end
    @form = ItemFindForm.new
  end

  def home
    if user_signed_in?
      @feed_items = current_user.feed_items
      @feed_comments = current_user.feed_comments
    else
      redirect_to root_path
    end
    @form = ItemFindForm.new
  end

  def popular
    if user_signed_in?
      user = current_user
    else
      user = User.new
    end
    # Ranking of last week (7days)
    # Stocked items
    @popular_items = user.popular_items
    # Liked comments
    @popular_comments = user.popular_comments
    # Followed users
    @popular_users = user.popular_users
    # Followed tags
    @popular_tags = user.popular_tags
  end

  def about
  end

  def help
  end

  def tos
  end

  def privacy
  end
end
