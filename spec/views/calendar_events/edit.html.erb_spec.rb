require 'rails_helper'

RSpec.describe "calendar_events/edit", type: :view do
  before(:each) do
    @calendar_event = assign(:calendar_event, CalendarEvent.create!(
      user: nil,
      name: "MyText",
      duration: ""
    ))
  end

  it "renders the edit calendar_event form" do
    render

    assert_select "form[action=?][method=?]", calendar_event_path(@calendar_event), "post" do

      assert_select "input[name=?]", "calendar_event[user_id]"

      assert_select "textarea[name=?]", "calendar_event[name]"

      assert_select "input[name=?]", "calendar_event[duration]"
    end
  end
end
