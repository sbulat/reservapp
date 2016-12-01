class AddDeletedAtToTables < ActiveRecord::Migration
  def change
    add_column :tables, :deleted_at, :datetime
  end
end
