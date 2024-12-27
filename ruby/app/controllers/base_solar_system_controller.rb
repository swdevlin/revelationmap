# frozen_string_literal: true

class BaseSolarSystemController < ApplicationController

  def index
    if parameters_are_ok?(params)
      solarsystems = solar_systems_query(params)
      render json: solarsystems
    else
      render plain: "either upper left sector x and y or all coordinates", status: :bad_request
    end
  end

  def parameters_are_ok?(params)
    required = [:ulsx, :ulsy]
    all_or_none = [:ulhx, :ulhy, :lrsx, :lrsy, :lrhx, :lrhy]

    if !required.all? { |param| params[param].present? }
      false
    else
      all_or_none.all? { |param| params[param].present? } || all_or_none.none? { |param| params[param].present? }
    end
  end

  def params_to_int(params)
    {
      ulsx: params[:ulsx].to_i,
      ulsy: params[:ulsy].to_i,
      ulhx: params[:ulhx].to_i,
      ulhy: params[:ulhy].to_i,
      lrsx: params[:lrsx].to_i,
      lrsy: params[:lrsy].to_i,
      lrhx: params[:lrhx].to_i,
      lrhy: params[:lrhy].to_i,
    }
  end

  def solar_systems_query(params)
    ulsx = params[:ulsx].to_i
    ulsy = params[:ulsy].to_i
    solar_systems = select_fields(SolarSystem.joins(:sector))

    if params[:ulhx].present?
      int_params = params_to_int(params)
      regions = sector_regions(int_params)
      solar_systems = add_clauses(solar_systems, regions)
    else
      solar_systems = solar_systems.where(sector: {x: ulsx, y: ulsy})
    end
    solar_systems.order("sector.x, sector.y, x, y")
    solar_systems
  end

  def sector_regions(params)
    ul = {
      sx: params[:ulsx],
      sy: params[:ulsy],
      hx: params[:ulhx],
      hy: params[:ulhy],
    }

    lr = {
      sx: params[:lrsx],
      sy: params[:lrsy],
      hx: params[:lrhx],
      hy: params[:lrhy],
    }

    regions = []

    if ul[:sx] == lr[:sx] && ul[:sy] == lr[:sy]
      regions << {
        sx: ul[:sx],
        sy: ul[:sy],
        minX: ul[:hx],
        maxX: lr[:hx],
        minY: ul[:hy],
        maxY: lr[:hy]
      }
    else
      (ul[:sx]..lr[:sx]).each do |x|
        (ul[:sy]).downto(lr[:sy]).each do |y|

          if x == ul[:sx]
            minX = ul[:hx]
            maxX = (x == lr[:sx] ? lr[:hx] : 32)
          elsif x > ul[:sx] && x < lr[:sx]
            minX = 1
            maxX = 32
          else
            minX = 1
            maxX = lr[:hx]
          end

          if y == ul[:sy]
            minY = ul[:hy]
            maxY = (x == lr[:sx] ? lr[:hy] : 40)
          elsif y < ul[:sy] && y > lr[:sy]
            minY = 1
            maxY = 40
          else
            minY = 1
            maxY = lr[:hy]
          end

          regions << {
            sx: x,
            sy: y,
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY
          }
        end
      end
    end

    regions
  end

  def add_clauses(query, regions)
    return query if regions.empty?

    # Add the first clause with `where`
    query = query.where(
      'sector.x = ? AND sector.y = ? AND solar_system.x BETWEEN ? AND ? AND solar_system.y BETWEEN ? AND ?',
      regions[0][:sx], regions[0][:sy],
      regions[0][:minX], regions[0][:maxX],
      regions[0][:minY], regions[0][:maxY]
    )

    # Add subsequent clauses with `or`
    regions[1..].each do |region|
      query = query.or(
        query.where(
          'sector.x = ? AND sector.y = ? AND solar_system.x BETWEEN ? AND ? AND solar_system.y BETWEEN ? AND ?',
          region[:sx], region[:sy],
          region[:minX], region[:maxX],
          region[:minY], region[:maxY]
        )
      )
    end

    query
  end

end
