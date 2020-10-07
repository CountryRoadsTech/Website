# frozen_string_literal: true

# This is the base model, that all other models in the application inherit from.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
