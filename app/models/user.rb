class User < ApplicationRecord
  ATR_PERMIT = %i(name email password password_confirmation).freeze
  has_many :memorials, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_many :memorial_relations, class_name: AccessPrivacy.name,
           foreign_key: :user_id, dependent: :destroy
  has_many :shared_memorial, through: :memorial_relations, source: :memorial
  has_one_attached :avatar

  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.length.digit_50}
  validates :email, presence: true,
            length: {maximum: Settings.length.digit_100},
            format: {with: Settings.email_regrex}, uniqueness: true
  validates :password, presence: true, allow_nil: true,
            length: {minimum: Settings.length.digit_6}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
