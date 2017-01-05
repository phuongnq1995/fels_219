class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :content
      t.references :word, index: true, foreign_key: true
      t.boolean :is_correct ,default: false

      t.timestamps null: false
    end
  end
end
