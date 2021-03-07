# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.text :url, null: false
      t.text :slug, null: false
      t.integer :number_of_times_used, default: 0

      t.timestamps
    end

    add_index :links, :slug, unique: true
  end
end
