require 'capybara/rails'
Capybara.server = :puma, { Silent: true }
Capybara.default_driver = :selenium
