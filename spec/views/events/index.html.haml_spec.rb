require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :title => "Title",
        :content => "MyText",
        :start_year => 1,
        :end_year => 2,
        :location => "",
        :type => nil,
        :source => "Source",
        :size => "Size",
        :published => false
      ),
      Event.create!(
        :title => "Title",
        :content => "MyText",
        :start_year => 1,
        :end_year => 2,
        :location => "",
        :type => nil,
        :source => "Source",
        :size => "Size",
        :published => false
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Source".to_s, :count => 2
    assert_select "tr>td", :text => "Size".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
