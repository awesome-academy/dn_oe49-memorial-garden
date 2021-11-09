class Contribution < ApplicationRecord
  enum contribution_type: {tribute: 0, story: 1, file: 2, flower: 3}

  belongs_to :memorial
  belongs_to :user
  has_one :attachment, dependent: :destroy
  has_one :story, dependent: :destroy
  has_one :tribute, dependent: :destroy
  has_one :flower, dependent: :destroy

  accepts_nested_attributes_for :tribute, :story, :attachment, :flower

  scope :search_by_memorial, ->(memorial){where memorial_id: memorial.id}

  validates :contribution_type, presence: true
  validates_each :contribution_type do |record, attr|
    if record.contribution_type.eql?("tribute")
      user = User.find_by(id: record.user_id)
      memorial = Memorial.find_by(id: record.memorial_id)
      record.errors.add(attr) if
        user.wrote_tribute?(memorial) && record.new_record?
    end
  end
end
