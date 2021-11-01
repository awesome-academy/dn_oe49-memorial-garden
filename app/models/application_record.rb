class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :search_by, (lambda do |type, name|
    where "#{type} LIKE ?", "%#{name}%" if name.present?
  end)
end
