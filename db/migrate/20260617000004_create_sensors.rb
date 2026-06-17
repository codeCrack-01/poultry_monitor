class CreateSensors < ActiveRecord::Migration[8.0]
  def change
    create_table :sensors do |t|
      t.references :zone, null: false, foreign_key: true
      t.integer :sensor_type, null: false
      t.string :label
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :sensors, :sensor_type
    add_index :sensors, :status
  end
end
