class RouteController < ApplicationController

  def index
    hexes = Route.all.order("year, day, ship_id")
    render json: hexes
  end

  def create
    @route = Route.create(route_params)
    if @route.save
      render json: @route, status: :created, location: @route
    else
      render json: @route.errors, status: :unprocessable_entity
    end
  end
  private
  def route_params
    params.expect(route: [:year, :day, :ship_id, :sector_x, :sector_y, :hex_x, :hex_y])
  end
end
