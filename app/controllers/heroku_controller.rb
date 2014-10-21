class HerokuController < ApplicationController
  authorize_resource

  # def agg(dynos)
  #   Rails.logger.info dynos
  #   [ 
  #     Dyno.new(Web,    dynos.inject(0) {|sum, d| (d.process == 'web'    and d.size == '1X' and d.count > 0) ? d.count : 0 }, '1X'),
  #     Dyno.new(Web,    dynos.inject(0) {|sum, d| (d.process == 'web'    and d.size == '2X' and d.count > 0) ? d.count : 0 }, '2X'),
  #     Dyno.new(Worker, dynos.inject(0) {|sum, d| (d.process == 'worker' and d.size == '1X' and d.count > 0) ? d.count : 0 }, '1X'),
  #     Dyno.new(Worker, dynos.inject(0) {|sum, d| (d.process == 'worker' and d.size == '2X' and d.count > 0) ? d.count : 0 }, '2X')
  #   ]
  # end

  # GET /scale/current
  # GET /scale/current.json
  def scale
    require 'timeout'

    @current_scale  = []
    
    config_vars_on  = {BACKGROUND_PROCESSING: true }
    config_vars_off = {BACKGROUND_PROCESSING: false}

    respond_to do |format|

      if params[:state]

        Timeout.timeout(10) do
          case params[:state].upcase
          when 'CURRENT'
            @current_scale = Topology.current ENV['APP_NAME']
            @current_config = ConfigVariable.current ENV['APP_NAME']
            format.html { render action: 'scale', status: :ok }      
          when 'UP'
            top = [Dyno.new(Worker, 2), Dyno.new(Web, 4)]
            @current_scale = Topology.scale ENV['APP_NAME'], top
            @current_config = ConfigVariable.set ENV['APP_NAME'], config_vars_on
          when 'DOWN'
            # top = [Dyno.new(Worker, 1), Dyno.new(Web, 1)]
            top = [Dyno.new(Worker, 1), Dyno.new(Web, 2)]
            @current_scale = Topology.scale ENV['APP_NAME'], top
            @current_config = ConfigVariable.set ENV['APP_NAME'], config_vars_off
          end
          format.html { redirect_to heroku_scale_path(state: 'current') }
        end    
      end

    end
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def scale_params
      params.require(:scale).permit(:state)
    end
end
