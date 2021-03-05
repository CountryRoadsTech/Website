# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'calendar_events/index', type: :view do
  before do
    assign(:calendar_events, [
             CalendarEvent.create!(
               user: nil,
               name: 'MyText',
               duration: ''
             ),
             CalendarEvent.create!(
               user: nil,
               name: 'MyText',
               duration: ''
             )
           ])
  end

  it 'renders a list of calendar_events' do
    render
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: ''.to_s, count: 2
  end
end
