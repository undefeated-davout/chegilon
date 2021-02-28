class ItemsController < ApplicationController
  include ApplicationHelper
  include TagsHelper

  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :get_item, only: [:show, :history, :edit, :update, :destroy, :stocking_users, :liking_users]
  before_action :correct_user, only: :destroy
  # --- Tags ---
  before_action :set_available_tags_with_count, only: [:new, :edit]
  before_action :set_item_tags_to_gon, only: :edit

  def index
    items = params[:tag] ? Item.where(active: true).tagged_with(params[:tag]) : Item.where(active: true)
    @tag = Tag.find_by(:name => params[:tag])
    @items = items.includes([:update_user]).page(params[:page])
    @fontsize = "middle"
  end

  def show
    redirect_to root_path unless @item.active
    @comment = @item.comments.build if user_signed_in?
    @comments = @item.comments.includes("user").page(params[:page])
    @fontsize = "large"
  end

  def history
  end

  def new
    @item = current_user.create_items.build if user_signed_in?
  end

  def create
    if @item = current_user.create_items.build(item_params) and
        @item.save and
        @comment = current_user.comments.build(:item_id => @item.id, :content => "[新規作成]") and
        @comment.save
      flash[:success] = "記事の投稿に成功しました。"
      redirect_to @item
    else
      @feed_items = []
      @feed_comments = []
      flash[:danger] = "記事の投稿に失敗しました。"
      render 'utility_pages/home'
    end
  end

  def edit
  end

  def update
    if @item.update_with_conflict_validation(item_params) and
        @comment = current_user.comments.build(:item_id => @item.id, :content => "[更新]" + @item.update_comment) and
        @comment.save
      flash[:success] = "記事の編集に成功しました。"
      redirect_to @item
    else
      flash[:danger] = "記事の編集に失敗しました。"
      render 'edit'
    end
  end

  def destroy
    if @item.update_attribute(:active, false)
      flash[:success] = "記事の削除に成功しました。"
    else
      flash[:danger] = "記事の削除に失敗しました。"
    end
    redirect_to request.referrer || root_url
  end

  def stocking_users
    @users = @item.item_stocking_users.reorder('item_stocks.updated_at DESC').page(params[:page])
  end

  # --- Markdown ---
  def api_markdown
    markdown = markdown(params[:text])
    render plain: markdown
  end

  # --- Search ---
  def search
    @keyword = params[:q].present? ? params[:q][:title_or_tag_list_entry_or_content_cont].to_s : ""
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true).order("updated_at DESC").page(params[:page]).limit(1000)
    # @sort_type = "お気に入り数順"
    # if params[:sort_type]
    #   @sort_type = params[:sort_type]
    # end
    # if params[:sort_type] == "更新日順"
    #   @items = @q.result(distinct: true).order("updated_at DESC").page(params[:page])
    # else
    #   @items = @q.result(distinct: true).includes(:item_stocks).order("count(item_stocks.id) DESC").page(params[:page])
    # end
  end


  private

  def item_params
    params[:item][:tag_list_entry] = params[:item][:tag_list]
    params.require(:item).permit(:lock_version, :title, :tag_list, :tag_list_entry, :content, :update_comment, :update_user_id)
  end

  def get_item
    @item = Item.find(params[:id])
  rescue
    redirect_to root_path
  end

  def correct_user
    redirect_to root_url if @item.nil? || @item.create_user != current_user
  end
end
