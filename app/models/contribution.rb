class Contribution < ApplicationRecord
  belongs_to :memorial
  belongs_to :user
  has_many :attachments, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :tribute, dependent: :destroy
  has_many :flowers, dependent: :destroy
  validates :contribution_type, presence: true
  validates :relationship, presence: true
end
