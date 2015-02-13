class UwLaEntry < ActiveRecord::Base
  def to_event
    Event.transaction do
      category = Category.where(name: uw_category).first_or_create!
      location = Location.where(abbr: uw_loc).first
      Event.create(id: uw_id, title: uw_title, content: uw_content, start_year: uw_start, end_year: uw_end,
                source: uw_source, size: uw_size, published: !uw_draft, category: category, location: location)
    end
  end
end
