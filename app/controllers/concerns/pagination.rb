# frozen_string_literal: true

# Used to provide pagination in views.
module Pagination
  extend ActiveSupport::Concern

  def paginate
    ->(records) { records.limit(number_of_items_per_page).offset(pagination_offset) }
  end

  def number_of_items_per_page
    params[:per_page]&.to_i or default_number_of_items_per_page
  end

  def default_number_of_items_per_page
    10
  end

  def pagination_offset
    (page_number - 1) * number_of_items_per_page
  end

  def page_number
    params[:page]&.to_i or 1
  end
end
