module MailChimpHelper


  def get_mailing_list

    @gb = Gibbon::API.new()
    # Rails.logger.info @mailchimp.lists
    # Rails.logger.info 'MailChimp'

    # Rails.logger.info @gb.list.inspect
    # @gb.lists['data'].each do |list|
    # Gibbon::API.lists.list do |total, list, errors|
    #   #Rails.logger.info "ListID: #{list['id']} Name: #{list['name']} isTrue? #{list['name'] == 'TeacherMaps Mailing List'}"
    #   Rails.logger.info "#{total.inspect} ---- #{list.inspect} ---- #{errors.inspect}\n\n"
    #   # if list['name'] == 'FestPix Information'
    #   #   return list['id']
    #   # end
    # end

    list = @gb.lists.list({filters:  {list_name: 'FestPix Information'}})
    Rails.logger.info "List: #{list.inspect}"

    if list and list.has_key?('data') and list['data'][0].has_key?('id')
      list['data'][0]['id']
    else
      false
    end
  end

  def subscribe_to_list( list_id, email_address )
    Rails.logger.info "Subscribing #{email_address} to mailing list #{list_id}"
    # @gb = Gibbon.new
    @gb = Gibbon::API.new()
    # @result = @gb.list_subscribe({
    #     id: list_id, 
    #     email_address: email_address,
    #     update_existing: true, 
    #     double_optin: false,
    #     merge_vars: {}
    # })
    @result = @gb.lists.subscribe({
      id: list_id, 
      email: {email: email_address},
      double_optin: false,
    })
    Rails.logger.info "Completed Subscription #{@result.inspect}"
    @result
  end





end