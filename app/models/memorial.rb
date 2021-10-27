class Memorial < ApplicationRecord
  ATR_PERMIT = %i(name gender cause_of_death relationship avatar).freeze

  scope :by_name_asc, ->{order :name}
  scope :search_by_name, ->(q){where "name LIKE ?", "%#{q}%" if q.present?}
  scope :find_user, ->(user){where user_id: user.id if user.present?}

  belongs_to :user
  has_many :placetimes, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_many :user_relations, class_name: AccessPrivacy.name,
           foreign_key: :memorial_id, dependent: :destroy
  has_many :shared_user, through: :user_relations, source: :user
  has_one_attached :avatar

  validates :name, presence: true, length: {maximum: Settings.length.digit_50}
  validates :relationship, presence: true

  def birth_date
    placetimes.select(&:is_born?).pop.date
  end

  def death_date
    placetimes.reject(&:is_born?).pop.date
  end
end
