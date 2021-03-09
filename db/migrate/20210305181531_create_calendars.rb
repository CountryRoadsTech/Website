# frozen_string_literal: true

class CreateCalendars < ActiveRecord::Migration[6.1]
  def change
    create_table :calendars, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.text :name, null: false

      t.timestamps
    end

    add_index :calendars, :name
  end
end
