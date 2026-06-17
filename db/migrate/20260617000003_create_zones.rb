class CreateZones < ActiveRecord::Migration[8.0]
  def change
    create_table :zones do |t|
      t.references :shed, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :zones, :status
  end
end
