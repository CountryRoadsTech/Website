class EnablePostgresqlSearchExtensions < ActiveRecord::Migration[6.1]
  def up
    say_with_time("Enabling Postgresql's unaccent extensions for use with full search") do
      execute <<~'SQL'
        CREATE EXTENSION IF NOT EXISTS unaccent;
      SQL
    end
  end

  def down
    say_with_time("Dropping Postgresql's unaccent extensions for use with full search") do
      execute <<~'SQL'
        DROP EXTENSION unaccent;
      SQL
    end
  end
end
