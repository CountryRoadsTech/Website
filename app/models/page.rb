# frozen_string_literal: true

# The Page model is used to display static, rich text pages on the site.
class Page < ApplicationRecord
  belongs_to :user, inverse_of: :pages

  has_rich_text :content

  validates :title, uniqueness: true
  validates :title, :user, presence: true

  extend FriendlyId # View pages at URLs based on their title not ID.
  friendly_id :title, use: :slugged
end
