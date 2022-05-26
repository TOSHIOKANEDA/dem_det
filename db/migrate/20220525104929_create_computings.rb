class CreateComputings < ActiveRecord::Migration[5.2]
  def change
    create_table :computings do |t|
      t.string :range, null: false
      t.string :dem_det, null: false
      t.integer :price, null: false
      t.integer :container_type, null: false
      t.integer :from, null: false
      t.integer :to, null: false
      t.string :port, null: false
      t.references :carrier, foreign_key: true
      t.references :free_calc, foreign_key: true
      t.timestamps
    end
  end
end
