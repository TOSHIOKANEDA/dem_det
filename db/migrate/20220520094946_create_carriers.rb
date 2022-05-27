class CreateCarriers < ActiveRecord::Migration[5.2]
  def change
    create_table :carriers do |t|
      t.string :name, null: false
      t.integer :active_flg, default: 0
      t.timestamps
    end
  end
end
