class RouteController < ApplicationController

  def index
    hexes = Route.all.order("year, day, ship_id")
    render json: hexes
  end

end
