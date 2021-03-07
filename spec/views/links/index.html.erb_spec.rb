# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'links/index', type: :view do
  before do
    assign(:links, [
             Link.create!(
               user: nil,
               url: 'MyText',
               slug: 'MyText',
               number_of_times_used: 2
             ),
             Link.create!(
               user: nil,
               url: 'MyText',
               slug: 'MyText',
               number_of_times_used: 2
             )
           ])
  end

  it 'renders a list of links' do
    render
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
  end
end
