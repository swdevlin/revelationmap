class Sector < ApplicationRecord
  self.table_name = 'sector' # Explicitly set table name (optional if the name matches)

  has_many :solar_systems, foreign_key: 'sector_id', dependent: :destroy
end
