json.array!(@events) do |event|
  json.extract! event, :id, :title, :content, :start_year, :end_year, :location, :category, :source, :size, :published
  json.url event_url(event, format: :json)
end
