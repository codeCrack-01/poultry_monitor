class CreateReadings < ActiveRecord::Migration[8.0]
  def change
    create_table :readings do |t|
      t.references :sensor, null: false, foreign_key: true
      t.decimal :value, precision: 10, scale: 2
      t.string :unit
      t.datetime :recorded_at, null: false

      t.timestamps
    end

    add_index :readings, [ :sensor_id, :recorded_at ]
  end
end
