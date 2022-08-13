class SurveyMailer < Devise::Mailer
  default from: "photos@festpix.com"

  def survey_email (params)
    @params = params
    mailto = ['admin@gmail.com']
    mailto.each do |e|
      mail(
        :from => "photos@festpix.com",
        :to => e,
        :subject => "New Festpix Survey Data").deliver
    end
  end
end
