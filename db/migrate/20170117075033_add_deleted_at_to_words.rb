class AddDeletedAtToWords < ActiveRecord::Migration
  def change
    add_column :words, :deleted_at, :datetime
    add_index :words, :deleted_at
  end
end
