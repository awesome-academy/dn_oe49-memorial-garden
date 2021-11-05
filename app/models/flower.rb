class Flower < ApplicationRecord
  ATR_PERMIT = %i(message flower_detail_id).freeze

  belongs_to :contribution
  belongs_to :flower_detail
  validates :message, length: {maximum: Settings.length.digit_200}
end
