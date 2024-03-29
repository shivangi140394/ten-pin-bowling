class CreateFrames < ActiveRecord::Migration[7.1]
  def change
    create_table :frames do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.text :rolls
      t.integer :number

      t.timestamps
    end
  end
end
