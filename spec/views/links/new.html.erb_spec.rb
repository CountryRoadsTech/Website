# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'links/new', type: :view do
  before do
    assign(:link, Link.new(
                    user: nil,
                    url: 'MyText',
                    slug: 'MyText',
                    number_of_times_used: 1
                  ))
  end

  it 'renders new link form' do
    render

    assert_select 'form[action=?][method=?]', links_path, 'post' do
      assert_select 'input[name=?]', 'link[user_id]'

      assert_select 'textarea[name=?]', 'link[url]'

      assert_select 'textarea[name=?]', 'link[slug]'

      assert_select 'input[name=?]', 'link[number_of_times_used]'
    end
  end
end
