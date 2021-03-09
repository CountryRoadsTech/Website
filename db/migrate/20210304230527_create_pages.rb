# frozen_string_literal: true

# The Page model is used to display static, rich text pages on the site.
class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.text :title, null: false
      t.text :slug, null: false
      t.text :subtitle, default: ''
      t.datetime :published_at

      t.timestamps
    end

    add_index :pages, :title, unique: true
    add_index :pages, :slug, unique: true
  end
end
