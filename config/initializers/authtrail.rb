# frozen_string_literal: true

# See https://github.com/ankane/authtrail#geocoding
AuthTrail.geocode = true
AuthTrail.job_queue = :low

# add or modify data
# AuthTrail.transform_method = lambda do |data, request|
#   data[:request_id] = request.request_id
# end

# exclude certain attempts from tracking
# AuthTrail.exclude_method = lambda do |data|
#   data[:identity] == "capybara@example.org"
# end
