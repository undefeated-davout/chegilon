class ItemStocksController < ApplicationController
  before_action :logged_in_user
  before_action :get_item, only: [:create, :destroy]

  def create
    current_user.item_stock(@item)
    respond_to do |format|
      format.html {redirect_to @item}
      format.js
    end
  end

  def destroy
    current_user.item_unstock(@item)
    respond_to do |format|
      format.html {redirect_to @item}
      format.js
    end
  end


  private

  def get_item
    @item = Item.find(params[:item_id])
  end
end
