class RouteController < ApplicationController

  def index
    hexes = Route
                 .joins("LEFT JOIN sector ON sector.x = route.sector_x AND sector.y = route.sector_y")
                 .joins("LEFT JOIN solar_system ON solar_system.x = route.hex_x AND solar_system.y = route.hex_y AND solar_system.sector_id = sector.id")
                 .select("route.*, sector.name AS sector_name, solar_system.name AS solar_system_name")
                 .all.order("year, day, ship_id")
                 .map do |route|
      route.as_json.merge(origin_x: calculate_origin_x(route), origin_y: calculate_origin_y(route))
    end
    render json: hexes
  end

  def create
    @route = Route.create(route_params)
    if @route.save
      SolarSystem.joins(:sector)
        .where(x: @route.hex_x, y: @route.hex_y, sector: { x: @route.sector_x, y: @route.sector_y }
        )
        .update_all(survey_index: 10)

      updateNeighbourSystems(@route)

      render json: @route, status: :created
    else
      render json: @route.errors, status: :unprocessable_entity
    end
  end

  private

  def route_params
    params.require(:route).permit(:year, :day, :ship_id, :sector_x, :sector_y, :hex_x, :hex_y)
  end

  def calculate_origin_x(route)
    route.sector_x * 32 + route.hex_x - 1
  end

  def calculate_origin_y(route)
    route.sector_y * 40 - route.hex_y + 1
  end

  def updateNeighbourSystems(route)
    neighbor_sql = <<~SQL
      UPDATE solar_system
      SET survey_index = GREATEST(5, COALESCE(survey_index, 0))
      FROM sector
      WHERE solar_system.sector_id = sector.id
        AND sector.x = ?
        AND sector.y = ?
        AND (
          (ABS(solar_system.x - ?) = 1 AND solar_system.y = ?)
          OR
          (solar_system.x = ? AND ABS(solar_system.y - ?) = 1)
          OR
          (ABS(solar_system.x - ?) = 1 AND ABS(solar_system.y - ?) = 1)
        )
    SQL

    ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.send(:sanitize_sql_array, [
        neighbor_sql,
        route.sector_x,
        route.sector_y,
        route.hex_x,
        route.hex_y,
        route.hex_x,
        route.hex_y,
        route.hex_x,
        route.hex_y
      ])
    )

  end

end
