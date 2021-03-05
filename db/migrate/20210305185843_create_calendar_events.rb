# frozen_string_literal: true

class CreateCalendarEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :calendar_events do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :calendar, null: false, foreign_key: true

      t.text :name, null: false
      t.text :slug, null: false
      t.daterange :duration, null: false

      t.timestamps
    end

    add_index :calendar_events, :name
    add_index :calendar_events, :slug, unique: true
  end
end
