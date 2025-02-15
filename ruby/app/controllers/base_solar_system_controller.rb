# frozen_string_literal: true

class BaseSolarSystemController < ApplicationController

  def index
    if parameters_are_ok?(params)
      solar_systems = solar_systems_query(params)
      render json: solar_systems
    else
      render plain: "either upper left sector x and y or all coordinates", status: :bad_request
    end
  end

  def parameters_are_ok?(params)
    sector = [:sx, :sy]
    box = [:ulx, :uly, :lrx, :lry]

    if sector.all? { |param| params[param].present? }
      true
    else
      box.all? { |param| params[param].present? }
    end
  end

  def solar_systems_query(params)
    sx = params[:sx]
    sy = params[:sy]

    if sx && sy
      ulx = sx.to_i * 32 + 1
      uly = sy.to_i * 40 - 1
      lrx = ulx + 31
      lry = uly - 39
    else
      ulx = params[:ulx].to_i
      uly = params[:uly].to_i
      lrx = params[:lrx].to_i
      lry = params[:lry].to_i
    end

    solar_systems = select_fields(SolarSystem.joins(:sector))
    solar_systems = solar_systems.where(
      "origin_x between symmetric ? and ? and origin_y between symmetric ? and ?",
      ulx, lrx, uly, lry)

    solar_systems.order("sector.x, sector.y, x, y")
    solar_systems
  end

end
