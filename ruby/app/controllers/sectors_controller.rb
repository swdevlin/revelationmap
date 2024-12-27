class SectorsController < ApplicationController

  # GET /sectors
  def index
    sectors = Sector.all
    render json: sectors
  end

end
