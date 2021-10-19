class Attachment < ApplicationRecord
  belongs_to :contribution
  has_one_attached :image
  has_one_attached :audio
  has_one_attached :video
end
