# frozen_string_literal: true

class AddLogidzeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE TRIGGER logidze_on_users
          BEFORE UPDATE OR INSERT ON users FOR EACH ROW
          WHEN (coalesce(current_setting('logidze.disabled', true), '') <> 'on')
          -- Parameters: history_size_limit (integer), timestamp_column (text), filtered_columns (text[]),
          -- include_columns (boolean), debounce_time_ms (integer)
          EXECUTE PROCEDURE logidze_logger(null, 'updated_at', '{email,unconfirmed_at,last_sign_in_ip,current_sign_in_ip}');

        SQL
      end

      dir.down do
        execute 'DROP TRIGGER IF EXISTS logidze_on_users on users;'
      end
    end
  end
end