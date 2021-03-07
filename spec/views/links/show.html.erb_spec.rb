# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'links/show', type: :view do
  before do
    @link = assign(:link, Link.create!(
                            user: nil,
                            url: 'MyText',
                            slug: 'MyText',
                            number_of_times_used: 2
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
  end
end
