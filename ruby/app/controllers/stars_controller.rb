class StarsController < BaseSolarSystemController
  def select_fields(query)
    fields = [
      'sector.x AS sector_x',
      'sector.y AS sector_y',
      'sector.name AS sector_name',
      'solar_system.id',
      'solar_system.x',
      'solar_system.y',
      'solar_system.origin_x',
      'solar_system.origin_y',
      'solar_system.name',
      'solar_system.scan_points',
      'solar_system.survey_index',
      'solar_system.gas_giant_count',
      'solar_system.terrestrial_planet_count',
      'solar_system.planetoid_belt_count',
      'solar_system.allegiance',
      'solar_system.stars'
    ]
    query.select(fields.join(", "))
  end
end
