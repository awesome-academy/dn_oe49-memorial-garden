class Tribute < ApplicationRecord
  ATR_PERMIT = %i(eulogy).freeze
  belongs_to :contribution
  belongs_to :rep_story, class_name: Tribute.name, optional: true
  has_many :rep_tributes, class_name: Tribute.name,
           foreign_key: :rep_tribute_id, dependent: :destroy

  validates :eulogy, presence: true,
            length: {maximum: Settings.length.digit_1000}

  scope :search_by_memorial, (lambda do |memorial|
    where contribution_id: memorial.contributions.tribute
  end)

  def belongs_user
    contribution.user
  end
end
