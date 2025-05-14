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

end
