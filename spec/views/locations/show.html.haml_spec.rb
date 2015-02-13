require 'rails_helper'

RSpec.describe "locations/show", type: :view do
  before(:each) do
    @location = assign(:location, Location.create!(
      :abbr => "Abbr",
      :top => 1,
      :left => 2,
      :name => "Name",
      :location => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Abbr/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
