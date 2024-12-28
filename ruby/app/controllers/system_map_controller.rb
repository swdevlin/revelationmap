class SystemMapController < ApplicationController
  def show
    begin
      sx = params[:sx].to_i
      sy = params[:sy].to_i
      hex = params[:hex]

      sector = Sector.find_by(x: sx, y: sy)
      unless sector
        render plain: 'Sector not found', status: :not_found
        return
      end

      file_path = Rails.root.join(ENV['STELLAR_DATA'], sector.name, "#{hex}-map.svg")

      unless File.exist?(file_path)
        render plain: 'SVG file not found', status: :not_found
        return
      end

      send_file file_path, type: 'image/svg+xml', disposition: 'inline'
    rescue => e
      Rails.logger.error("Error retrieving system map: #{e.message}")
      render plain: e.message, status: :internal_server_error
    end
  end
end
