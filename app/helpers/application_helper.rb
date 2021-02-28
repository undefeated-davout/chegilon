module ApplicationHelper
  # Return complete title each pages
  def full_title(page_title = '')
    base_title = "Chegilon"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # set mata tags for SNS
  def default_meta_tags
    {
        title: full_title,
        description: 'Chegilonは、知恵やノウハウを共有し議論するためのサービスです。',
        keywords: '知恵, 議論, 共有, ノウハウ',
        twitter: {
            card: 'product',
            site: '@Chegilon',
            description: :description,
            image: ENV["APPLI_URL"] + asset_path("card_logo.png")
        },
        og: {
            title: :title,
            type: 'website',
            url: request.url,
            image: ENV["APPLI_URL"] + asset_path("card_logo.png"),
            description: :description
        }
    }
  end

  # Checking user, logging in user or not.
  def current_user?(user)
    user == current_user
  end

  def footer_display_page?(controller, action)
    controller == "items" && (action == "new" || action == "edit")
  end

  def target_action?(controller, controller_name, action_names)
    controller.controller_name == controller_name && action_names.include?(controller.action_name)
  end

  def active_class(controller, controller_name, action_names)
    'active' if target_action?(controller, controller_name, action_names)
  end
end
