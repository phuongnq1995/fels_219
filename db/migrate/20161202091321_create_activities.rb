class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :action
      t.references :user, index: true, foreign_key: true
      t.integer :target_id

      t.timestamps null: false
    end
    add_index :activities, [:user_id, :created_at]
  end
end
