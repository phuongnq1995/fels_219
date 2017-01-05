class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :result
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :lessons, [:user_id, :created_at]
  end
end
