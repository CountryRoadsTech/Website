# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'calendar_events/new', type: :view do
  before do
    assign(:calendar_event, CalendarEvent.new(
                              user: nil,
                              name: 'MyText',
                              duration: ''
                            ))
  end

  it 'renders new calendar_event form' do
    render

    assert_select 'form[action=?][method=?]', calendar_events_path, 'post' do
      assert_select 'input[name=?]', 'calendar_event[user_id]'

      assert_select 'textarea[name=?]', 'calendar_event[name]'

      assert_select 'input[name=?]', 'calendar_event[duration]'
    end
  end
end
