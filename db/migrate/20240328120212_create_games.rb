class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.text :rolls, array: true, default: []
      t.timestamps
    end
  end
end
