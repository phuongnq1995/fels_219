class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :word, index: true, foreign_key: true
      t.references :lesson, index: true, foreign_key: true
      t.references :answer, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :questions, [:lesson_id, :word_id]
  end
end
