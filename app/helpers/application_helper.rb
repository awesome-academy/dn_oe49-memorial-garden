module ApplicationHelper
  def full_title page_title = ""
    base_title = t("base_title")
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def avatar_for user
    return image_tag user.avatar if User.first.avatar.attached?

    image_tag("avatar-none.jpg", class: "gravatar")
  end
end
