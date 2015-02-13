require 'rails_helper'

RSpec.describe "locations/index", type: :view do
  before(:each) do
    assign(:locations, [
      Location.create!(
        :abbr => "Abbr",
        :top => 1,
        :left => 2,
        :name => "Name",
        :location => ""
      ),
      Location.create!(
        :abbr => "Abbr",
        :top => 1,
        :left => 2,
        :name => "Name",
        :location => ""
      )
    ])
  end

  it "renders a list of locations" do
    render
    assert_select "tr>td", :text => "Abbr".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
