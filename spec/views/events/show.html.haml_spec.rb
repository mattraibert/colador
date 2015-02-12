require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :title => "Title",
      :content => "MyText",
      :start_year => 1,
      :end_year => 2,
      :location => "",
      :type => nil,
      :source => "Source",
      :size => "Size",
      :published => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Source/)
    expect(rendered).to match(/Size/)
    expect(rendered).to match(/false/)
  end
end
