# frozen_string_literal: true

# This is the base helper, that all other helpers in the application inherit from.
module ApplicationHelper
  # This method is used to load in Bootstrap Icons SVGs and embed them within views.
  def icon(icon, options = {})
    file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css('svg')

    # Add any of Bootstrap's class options, if provided.
    svg['class'] += " #{options[:class]}" if options[:class].present?

    # rubocop:disable Rails/OutputSafety
    doc.to_html.html_safe
    # rubocop:enable Rails/OutputSafety
  end
end
