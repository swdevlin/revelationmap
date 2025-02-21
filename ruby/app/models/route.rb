class Route < ApplicationRecord
  self.table_name = "route"

  validates :ship_id, :year, :day, :sector_x, :sector_y, :hex_x, :hex_y, presence: true
  belongs_to :sector, foreign_key: [:sector_x, :sector_y], primary_key: [:x, :y], optional: true
end
