# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'links/edit', type: :view do
  before do
    @link = assign(:link, Link.create!(
                            user: nil,
                            url: 'MyText',
                            slug: 'MyText',
                            number_of_times_used: 1
                          ))
  end

  it 'renders the edit link form' do
    render

    assert_select 'form[action=?][method=?]', link_path(@link), 'post' do
      assert_select 'input[name=?]', 'link[user_id]'

      assert_select 'textarea[name=?]', 'link[url]'

      assert_select 'textarea[name=?]', 'link[slug]'

      assert_select 'input[name=?]', 'link[number_of_times_used]'
    end
  end
end
