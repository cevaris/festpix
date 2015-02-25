module ApplicationHelper
  

  def is_production?
    ENV['HOST_URL'].include?('festpix.herokuapp.com') || ENV['HOST_URL'] == 'http://www.festpix.com'
  end

end
