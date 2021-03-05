# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'calendar_events/show', type: :view do
  before do
    @calendar_event = assign(:calendar_event, CalendarEvent.create!(
                                                user: nil,
                                                name: 'MyText',
                                                duration: ''
                                              ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
