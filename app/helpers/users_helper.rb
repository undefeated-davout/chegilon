module UsersHelper
  def exit_user_name
    "退会済み"
  end

  # Getting user's Gravatar image
  def gravatar_for(user, options = {size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def exit_user_image(options = {size: 80})
    image_tag("exit_user.png", alt: exit_user_name, class: "gravatar", size: options)
  end
end
