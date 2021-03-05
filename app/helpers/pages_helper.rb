# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id           :bigint           not null, primary key
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
# The Page model is used to display static, rich text pages on the site.
module PagesHelper
end
