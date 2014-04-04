class EmailController < ApplicationController
  

  def new
    
  end

  # GET /email/1/email
  def email

    Rails.logger.info params

    return render nothing: true, status: 500 unless params.has_key? 'email'

    list_id = get_mailing_list()

    if list_id and subscribe_to_list( ist_id, params[:email] )
      return render nothing: true
    else
      return render nothing: true, status: 500
    end       
    
  end
end
