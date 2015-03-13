class HomeController < ApplicationController
  def index
  end

  def survey
  end

  def complete_survey
    SurveyMailer.survey_email(params)
    redirect_to new_user_registration_path
  end

  def render_timeout
    sleep 50
    render :status => 200, text: ''
  end
end
