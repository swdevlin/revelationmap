class Route < ApplicationRecord
  self.table_name = 'route'

  validates :ship_id, :year, :day, :sector_x, :sector_y, :hex_x, :hex_y, presence: true
end
