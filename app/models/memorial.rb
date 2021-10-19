class Memorial < ApplicationRecord
  belongs_to :user
  has_many :placetimes, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_many :user_relations, class_name: AccessPrivacy.name,
           foreign_key: :memorial_id, dependent: :destroy
  has_many :shared_user, through: :user_relations, source: :user
  has_one_attached :avatar

  validates :name, presence: true, length: {maximum: Settings.length.digit_50}
  validates :relationship, presence: true
end
