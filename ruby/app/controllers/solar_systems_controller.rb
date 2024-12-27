class SolarSystemsController < BaseSolarSystemController
  def select_fields(query)
    query.select("sector.x as sector_x, sector.y as sector_y, sector.name as sector_name, solar_system.*")
  end
end
