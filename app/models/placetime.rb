class Placetime < ApplicationRecord
  ATR_PERMIT = %i(location date is_born).freeze

  belongs_to :memorial
end
