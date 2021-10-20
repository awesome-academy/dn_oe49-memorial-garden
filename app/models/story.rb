class Story < ApplicationRecord
  belongs_to :contribution
  belongs_to :rep_story, class_name: Story.name, optional: true
  has_many :rep_stories, class_name: Story.name,
           foreign_key: :rep_story_id, dependent: :destroy

  validates :content, presence: true,
            length: {maximum: Settings.length.digit_1000}
end
