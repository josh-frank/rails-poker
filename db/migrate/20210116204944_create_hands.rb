class CreateHands < ActiveRecord::Migration[6.1]
  def change
    create_table :hands do |t|
      t.string :cards
      t.string :hold_cards
      t.integer :deck_min
      t.integer :deck_max
      t.boolean :drawn

      t.timestamps
    end
  end
end
