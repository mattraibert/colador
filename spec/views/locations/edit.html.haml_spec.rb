require 'rails_helper'

RSpec.describe "locations/edit", type: :view do
  before(:each) do
    @location = assign(:location, Location.create!(
      :abbr => "MyString",
      :top => 1,
      :left => 1,
      :name => "MyString",
      :location => ""
    ))
  end

  it "renders the edit location form" do
    render

    assert_select "form[action=?][method=?]", location_path(@location), "post" do

      assert_select "input#location_abbr[name=?]", "location[abbr]"

      assert_select "input#location_top[name=?]", "location[top]"

      assert_select "input#location_left[name=?]", "location[left]"

      assert_select "input#location_name[name=?]", "location[name]"

      assert_select "input#location_location[name=?]", "location[location]"
    end
  end
end
