# == Schema Information
#
# Table name: links
#
#  id                   :bigint           not null, primary key
#  number_of_times_used :integer          default(0)
#  slug                 :text             not null
#  url                  :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_links_on_slug     (slug) UNIQUE
#  index_links_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_005e9b2a6a  (user_id => users.id)
#
class Link < ApplicationRecord
  belongs_to :user, inverse_of: :links

  validates :user, :url, :slug, presence: true
  validates_uniqueness_of :slug
  validates :url, format: URI::regexp(%w[http https])
end
