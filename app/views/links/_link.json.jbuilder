# frozen_string_literal: true

json.extract! link, :id, :user_id, :url, :slug, :number_of_times_used, :created_at, :updated_at
json.url link_url(link, format: :json)
