class User < ApplicationRecord
  ATR_PERMIT = %i(name email password password_confirmation
                  gender avatar).freeze

  scope :unshared_member, (lambda do |memorial|
    where.not id: memorial.shared_users.ids << memorial.user.id
  end)

  has_many :memorials, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_many :memorial_relations, class_name: AccessPrivacy.name,
           foreign_key: :user_id, dependent: :destroy
  has_many :shared_memorials, through: :memorial_relations, source: :memorial
  has_one_attached :avatar

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.length.digit_50}
  validates :email, presence: true,
            length: {maximum: Settings.length.digit_100},
            format: {with: Settings.email_regrex}, uniqueness: true
  validates :password, presence: true, allow_nil: true,
            length: {minimum: Settings.length.digit_6}

  has_secure_password

  def leave_a_tribute memorial, eulogy, relationship = nil
    contributions.create(memorial_id: memorial.id, relationship: relationship,
      contribution_type: 0, tribute_attributes: {eulogy: eulogy})
  end

  def wrote_tribute? memorial
    contributions.tribute.search_by_memorial(memorial).present?
  end

  def show_tribute memorial
    contributions.tribute.search_by_memorial(memorial)&.first&.tribute
  end

  private

  def downcase_email
    email.downcase!
  end
end
