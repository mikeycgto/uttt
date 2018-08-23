class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.text      :board, null: false
      t.text      :valid_subgames, null: false
      t.text      :won_subgames, null: false
      t.string    :turn, null: false
      t.boolean   :completed, default: false, null: false

      t.timestamps
    end
  end
end
