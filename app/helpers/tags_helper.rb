module TagsHelper
  def set_item_tags_to_gon
    gon.item_tags = @item.tag_list_entry.split(",") if @item.tag_list_entry
  end

  def set_available_tags_with_count
    tag_list_with_count = []
    # get tags and sort by item count
    tag_list = Item.tags_on(:tags).pluck(:name, :taggings_count).sort {|a, b| b[1] <=> a[1]}
    tag_list.each do |tag|
      name = tag[0] + '(' + tag[1].to_s + ')'
      tag_list_with_count.push(name)
    end
    gon.available_tags = tag_list_with_count
  end

  def tag_cloud
    @tags = Tag.order("taggings_count DESC").page(params[:page])
  end
end
