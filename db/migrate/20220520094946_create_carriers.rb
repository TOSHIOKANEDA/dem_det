class CreateCarriers < ActiveRecord::Migration[5.2]
  def change
    create_table :carriers do |t|
      t.string :name, null: false
      t.string :range, null: false
      t.string :dem_det, null: false
      t.integer :price, null: false
      t.integer :container_type, null: false
      t.integer :from, null: false
      t.integer :to, null: false
      t.string :port, null: false
      t.integer :free, null: false
      t.integer :calc, null: false
      t.timestamps
    end
  end
end
