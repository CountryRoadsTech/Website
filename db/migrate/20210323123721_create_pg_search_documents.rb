class CreatePgSearchDocuments < ActiveRecord::Migration[6.1]
  def up
    say_with_time('Creating table for pg_search multisearch') do
      create_table :pg_search_documents, id: :uuid do |t|
        t.text :content
        t.references :user, index: true, type: :uuid
        t.belongs_to :searchable, polymorphic: true, index: true, type: :uuid
        t.timestamps null: false
      end
    end
  end

  def down
    say_with_time('Dropping table for pg_search multisearch') do
      drop_table :pg_search_documents
    end
  end
end
