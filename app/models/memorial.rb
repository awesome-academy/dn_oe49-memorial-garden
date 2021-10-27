class Memorial < ApplicationRecord
  ATR_PERMIT = %i(name gender cause_of_death relationship avatar).freeze

  scope :by_name_asc, ->{order :name}
  scope :search_by_name, (lambda do |name|
    where "name LIKE ?", "%#{name}%" if name.present?
  end)
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

  def placetimes_attributes= placetimes_attributes
    placetimes_attributes.each do |num, params|
      is_born = num.eql?("0")
      date = format_date params
      placetimes.build(location: params[:location],
        date: date, is_born: is_born)
    end
  end

  def format_date name
    form_array = %w(1 2 3).map{|e| name["date(#{e}i)"].to_i}
    return if form_array.include? 0

    Date.new(*form_array)
  end

  def build_placetimes
    2.times{placetimes.build}
  end

  def date type
    placetimes.send(type.eql?(:birth) ? :select : :reject, &:is_born?).pop.date
  end
end
