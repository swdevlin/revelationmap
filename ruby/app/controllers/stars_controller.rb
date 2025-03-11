class StarsController < BaseSolarSystemController
  before_action :set_star, only: %i[update]

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
      'solar_system.native_sophont',
      'solar_system.extinct_sophont',
      "(solar_system.main_world->>'techLevel')::INTEGER as tech_level",
      'solar_system.stars'
    ]
    query.select(fields.join(", "))
  end

  def update
    if @star.update(star_params)
      render json: @star
    else
      render json: { errors: @star.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_star
    @star = SolarSystem.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Star not found' }, status: :not_found
  end

  def star_params
    params.require(:star).permit(:survey_index, :name)
  end
end
