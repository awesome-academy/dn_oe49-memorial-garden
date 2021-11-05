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
    return image_tag(user.avatar, class: "gravatar") if user.avatar.attached?

    image_tag("avatar-none.jpg", class: "gravatar")
  end

  def image_for flower
    image_tag(flower.flower_detail.image, class: "image_flower")
  end

  def show_date_of model, type
    full_detail_date = model.send(:date, type)
    return "?" if full_detail_date.blank?

    l full_detail_date, format: :default
  end

  def birth_and_death_year model
    birth_year = model.send(:year, :birth)
    death_year = model.send(:year, :death)
    "#{birth_year}-#{death_year}"
  end
end
