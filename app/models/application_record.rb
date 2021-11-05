class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :search_by, (lambda do |type, name|
    where "#{type} LIKE ?", "%#{name}%" if name.present?
  end)
  scope :search_by_memorial, (lambda do |memorial, type_of|
    where contribution_id: memorial.contributions.send(type_of)
  end)
  scope :newest, ->{order created_at: :desc}

  def belongs_user
    contribution.user
  end
end
