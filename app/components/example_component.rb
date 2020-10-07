# frozen_string_literal: true

# This is simply an example view component.
class ExampleComponent < ViewComponent::Base
  def initialize(title:, body:)
    super

    @title = title
    @body = body
  end
end
