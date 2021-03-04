# frozen_string_literal: true

json.extract! page, :id, :user_id, :title, :subtitle, :content, :published_at, :created_at, :updated_at
json.url page_url(page, format: :json)
