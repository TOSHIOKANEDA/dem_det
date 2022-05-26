class CreateFreeCalcs < ActiveRecord::Migration[5.2]
  def change
    create_table :free_calcs do |t|
      t.integer :free_day, null: false
      t.integer :calc_method, null: false
      t.integer :start_count, null: false
      t.timestamps
    end
  end
end
