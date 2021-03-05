# frozen_string_literal: true

class CreateCalendars < ActiveRecord::Migration[6.1]
  def change
    create_table :calendars do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.text :name, null: false

      t.timestamps
    end

    add_index :calendars, :name
  end
end
