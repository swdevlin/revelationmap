class SolarSystemController < BaseSolarSystemController

  def show
    if parameters_are_ok?(params)
      sx = params[:sx].to_i
      sy = params[:sy].to_i
      hx = params[:hx].to_i
      hy = params[:hy].to_i

      solar_system = SolarSystem
        .joins(:sector)
        .select('solar_system.*',
          'sector.x AS sector_x',
          'sector.y AS sector_y',
          'sector.name AS sector_name'
        )
        .find_by(
      "solar_system.x = ? and solar_system.y = ? and sector.x = ? and sector.y = ?", hx, hy, sx, sy
        )

      if solar_system.nil?
        render plain: 'solar system not found', status: :not_found
      else
        render json: solar_system
      end
    else
      render plain: "sx, sy, hx, hy required", status: :bad_request
    end
  end

  private

  def params_to_int(params)
    {
      sx: params[:ulsx].to_i,
      sy: params[:ulsy].to_i,
      hx: params[:ulhx].to_i,
      hy: params[:ulhy].to_i,
      lrsx: params[:lrsx].to_i,
      lrsy: params[:lrsy].to_i,
      lrhx: params[:lrhx].to_i,
      lrhy: params[:lrhy].to_i,
    }
  end

  def parameters_are_ok?(params)
    required = [:sx, :sy, :hx, :hy]
    required.all? { |param| params[param].present? }
  end

end
