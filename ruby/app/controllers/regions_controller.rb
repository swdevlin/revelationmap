class RegionsController < ApplicationController

  # GET /sectors
  def index
    regions = Region.all
    render json: regions
  end

end
