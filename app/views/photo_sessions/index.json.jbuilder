json.array!(@photo_sessions) do |photo_session|
  json.extract! photo_session, :id, :name, :photo_user_id, :event_id
  json.url photo_session_url(photo_session, format: :json)
end
