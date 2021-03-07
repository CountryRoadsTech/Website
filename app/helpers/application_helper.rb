# frozen_string_literal: true

# Helper methods here are available across the application (where model-specific helpers are available).
module ApplicationHelper
  # Embeds Bootstrap SVG icons into HTML.
  def icon(icon, options = {})
    file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css('svg')

    # Apply any of Bootstrap's classes, if provided.
    svg['class'] += " #{options[:class]}" if options[:class].present?

    doc.to_html.html_safe
  end
end
