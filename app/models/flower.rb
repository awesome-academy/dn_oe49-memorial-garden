class Flower < ApplicationRecord
  belongs_to :contribution
  validates :message, presence: true,
            length: {maximum: Settings.length.digit_200}
end
