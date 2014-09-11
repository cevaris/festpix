json.array!(@events) do |event|
  json.extract! event, :id, :slug, :name, :logo
  json.url event_url(event, format: :json)
end
