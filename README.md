# Festpix

## Image processing

## Reprocess a specific image style

    Photo.find_each {|x| puts x.id; x.image.reprocess!(:medium) if x.photo_session and x.photo_session.event and x.photo_session.event.save }
    Event.all.each {|e| puts e.id; e.watermark.reprocess!(:xlarge); e.save}

## Metrics

    # Random facebook sharer for given event
    e = Event.find_by_slug 'smakpakparty'; PhotoSession.all.where(event_id: e.id).select {|ps| ps.facebook_shares > 0}.sample
    # Random facebook sharer for given event made today
    e = Event.find_by_slug 'smakpakparty'; PhotoSession.all.where(event_id: e.id).where("DATE(created_at) = DATE(?)", Time.now).select {|ps| ps.facebook_shares > 0}.sample
    # Random facebook sharer phone numbers for given event made today 
    e = Event.find_by_slug 'smakpakparty'; PhotoSession.all.where(event_id: e.id).where("DATE(created_at) = DATE(?)", Time.now).select {|ps| ps.facebook_shares > 0}.sample.phone_list

## Looking up photo session via phone number

    PhotoSession.tagged_with '2069638269'

## Count all unique phone numbers


    PhotoSession.all.map {|x| x.phone_list}.uniq


## Count all opened photos

    PhotoSession.where(event_id: (Event.all.ids - [1])).select {|x| x.is_opened?}.count

## Frame watermarking

    Paperclip.run('convert',' /tmp/xframe.png /tmp/original.jpg -gravity center -compose DstOver -composite /tmp/example1.jpg')
