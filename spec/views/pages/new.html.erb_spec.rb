# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/new', type: :view do
  before do
    assign(:page, Page.new(
                    user: nil,
                    title: 'MyText',
                    subtitle: 'MyText',
                    slug: 'MyText'
                  ))
  end

  it 'renders new page form' do
    render

    assert_select 'form[action=?][method=?]', pages_path, 'post' do
      assert_select 'input[name=?]', 'page[user_id]'

      assert_select 'textarea[name=?]', 'page[title]'

      assert_select 'textarea[name=?]', 'page[subtitle]'

      assert_select 'textarea[name=?]', 'page[slug]'
    end
  end
end
