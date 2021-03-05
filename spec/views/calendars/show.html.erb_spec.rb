# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'calendars/show', type: :view do
  before do
    @calendar = assign(:calendar, Calendar.create!(
                                    user: nil,
                                    calendar_events: '',
                                    name: 'MyText'
                                  ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
  end
end
