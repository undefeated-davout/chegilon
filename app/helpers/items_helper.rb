module ItemsHelper
  def deleted_item_title
    "削除済みの記事"
  end

  def deletable_item_stock_count
    5
  end

  # --- Markdowns ---
  def markdown(text)
    unless text
      return ""
    end
    renderer = Redcarpet::Render::HTML.new(
        autolink: true,
        space_after_headers: false,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        tables: true,
        hard_wrap: true,
        xhtml: true,
        lax_html_blocks: true,
        strikethrough: true)
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    ((redcarpet.render text).encode("UTF-16BE", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8")).html_safe
  end
end
