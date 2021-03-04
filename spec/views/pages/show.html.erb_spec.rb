# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'pages/show', type: :view do
  before do
    @page = assign(:page, Page.create!(
                            user: nil,
                            title: 'MyText',
                            subtitle: 'MyText',
                            slug: 'MyText'
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
