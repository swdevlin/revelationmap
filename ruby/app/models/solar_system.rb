class SolarSystem < ApplicationRecord
  validates :survey_index, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 12 }, allow_nil: true
  self.table_name = 'solar_system'

  belongs_to :sector, foreign_key: 'sector_id'
end
