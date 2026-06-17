class CreateAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :alerts do |t|
      t.references :farm, null: false, foreign_key: true
      t.references :zone, foreign_key: true
      t.references :sensor, foreign_key: true
      t.string :alert_type, null: false
      t.integer :severity, null: false
      t.string :message
      t.decimal :value, precision: 10, scale: 2
      t.integer :status, default: 0, null: false
      t.datetime :resolved_at

      t.timestamps
    end

    add_index :alerts, :severity
    add_index :alerts, :status
    add_index :alerts, [:farm_id, :status]
  end
end
