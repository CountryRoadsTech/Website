# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/index', type: :view do
  before do
    assign(:pages, [
             Page.create!(
               user: nil,
               title: 'MyText',
               subtitle: 'MyText',
               slug: 'MyText'
             ),
             Page.create!(
               user: nil,
               title: 'MyText',
               subtitle: 'MyText',
               slug: 'MyText'
             )
           ])
  end

  it 'renders a list of pages' do
    render
    assert_select 'tr>td', text: nil.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
    assert_select 'tr>td', text: 'MyText'.to_s, count: 2
  end
end
