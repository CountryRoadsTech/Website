# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/edit', type: :view do
  before do
    @page = assign(:page, Page.create!(
                            user: nil,
                            title: 'MyText',
                            subtitle: 'MyText',
                            slug: 'MyText'
                          ))
  end

  it 'renders the edit page form' do
    render

    assert_select 'form[action=?][method=?]', page_path(@page), 'post' do
      assert_select 'input[name=?]', 'page[user_id]'

      assert_select 'textarea[name=?]', 'page[title]'

      assert_select 'textarea[name=?]', 'page[subtitle]'

      assert_select 'textarea[name=?]', 'page[slug]'
    end
  end
end
