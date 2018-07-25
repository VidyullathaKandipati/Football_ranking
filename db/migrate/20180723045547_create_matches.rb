class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :name
      t.string :team1
      t.string :team2
      t.string :winner
      t.string :loser

      t.timestamps null: false
    end
  end
end
