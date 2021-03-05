# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'calendars/edit', type: :view do
  before do
    @calendar = assign(:calendar, Calendar.create!(
                                    user: nil,
                                    calendar_events: '',
                                    name: 'MyText'
                                  ))
  end

  it 'renders the edit calendar form' do
    render

    assert_select 'form[action=?][method=?]', calendar_path(@calendar), 'post' do
      assert_select 'input[name=?]', 'calendar[user_id]'

      assert_select 'input[name=?]', 'calendar[calendar_events]'

      assert_select 'textarea[name=?]', 'calendar[name]'
    end
  end
end
