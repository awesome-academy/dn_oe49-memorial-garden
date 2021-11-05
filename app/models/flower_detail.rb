class FlowerDetail < ApplicationRecord
  has_one_attached :image
  has_many :flowers, dependent: :destroy

  def translated_name
    I18n.t(name, scope: "flower_name")
  end
end
