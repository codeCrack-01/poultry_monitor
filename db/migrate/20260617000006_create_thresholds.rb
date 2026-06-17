class CreateThresholds < ActiveRecord::Migration[8.0]
  def change
    create_table :thresholds do |t|
      t.integer :sensor_type, null: false
      t.decimal :warning_min, precision: 10, scale: 2
      t.decimal :warning_max, precision: 10, scale: 2
      t.decimal :critical_min, precision: 10, scale: 2
      t.decimal :critical_max, precision: 10, scale: 2

      t.timestamps
    end

    add_index :thresholds, :sensor_type, unique: true
  end
end
