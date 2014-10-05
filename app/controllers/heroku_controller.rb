class HerokuController < ApplicationController
  authorize_resource

  # GET /scale/up
  # GET /scale/up.json
  def scale
    @scale = []


    respond_to do |format|

      if params[:state]
        
        case params[:state].upcase
        when 'CURRENT'
          @scale = Topology.current(ENV['APP_NAME'])
          format.html { render action: 'scale', status: :ok }      
        when 'UP'
          top = [Dyno.new(Worker, 2), Dyno.new(Web, 4)]
          @scale = Topology.scale(ENV['APP_NAME'],top)
        when 'DOWN'
          # top = [Dyno.new(Worker, 1), Dyno.new(Web, 1)]
          top = [Dyno.new(Worker, 0), Dyno.new(Web, 1)]
          @scale = Topology.scale(ENV['APP_NAME'],top)
        end
        format.html { redirect_to heroku_scale_path(state: 'current') }
        
      end

    end
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def scale_params
      params.require(:scale).permit(:state)
    end
end
