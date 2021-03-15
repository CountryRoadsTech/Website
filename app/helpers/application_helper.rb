# frozen_string_literal: true

# Helper methods here are available across the application (where model-specific helpers are available).
module ApplicationHelper
  # Embeds Bootstrap SVG icons into HTML.
  def icon(icon, options = {})
    begin
      file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    rescue Errno::ENOENT
      Rails.logger.warn "Unknown icon cannot be created (name unknown): #{icon}"
      return # Simply return nothing if the passed in icon does not exist.
    end

    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css('svg')

    # Apply any of Bootstrap's classes, if provided.
    svg['class'] += " #{options[:class]}" if options[:class].present?

    doc.to_html.html_safe
  end
end
