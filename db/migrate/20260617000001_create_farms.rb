class CreateFarms < ActiveRecord::Migration[8.0]
  def change
    create_table :farms do |t|
      t.string :name, null: false
      t.string :location
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :farms, :status
  end
end
