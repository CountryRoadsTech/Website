# frozen_string_literal: true

# All other models inherit from this model.
# Any behavior here is done across all models.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
