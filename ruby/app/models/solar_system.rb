class SolarSystem < ApplicationRecord
  self.table_name = 'solar_system'

  belongs_to :sector, foreign_key: 'sector_id'
end
