# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id           :bigint           not null, primary key
#  log_data     :jsonb
#  published_at :datetime
#  slug         :text             not null
#  subtitle     :text             default("")
#  title        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_pages_on_slug     (slug) UNIQUE
#  index_pages_on_title    (title) UNIQUE
#  index_pages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_84a58494eb  (user_id => users.id)
#
class Page < ApplicationRecord
  belongs_to :user, inverse_of: :pages

  has_rich_text :content

  validates :title, uniqueness: true
  validates :title, :user, :content, presence: true

  has_logidze # Track and store changes to this model.

  extend FriendlyId # View pages at URLs based on their title not ID.
  friendly_id :title, use: :slugged

  # Use Hotwire to send live updates (via Action Cable) to the user's browser.
  after_create_commit { broadcast_prepend_to 'pages' }
  after_update_commit { broadcast_replace_to 'pages' }
  after_destroy_commit { broadcast_remove_to 'pages' }
end
