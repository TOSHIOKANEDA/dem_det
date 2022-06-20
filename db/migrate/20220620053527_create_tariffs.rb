class CreateTariffs < ActiveRecord::Migration[5.2]
  def change
    create_table :tariffs do |t|
      t.string :name, null: false, default: ""
      t.string :calc, null: false, default: ""
      t.string :free, null: false, default: ""
      t.string :first_from, null: false, default: "1"
      t.string :first_to, null: false, default: "999"
      t.string :first_amount, null: false, default: "0"
      t.string :second_from, null: false, default: "999"
      t.string :second_to, null: false, default: "999"
      t.string :second_amount, null: false, default: "0"
      t.string :third_from, null: false, default: "999"
      t.string :third_to, null: false, default: "999"
      t.string :third_amount, null: false, default: "0"
      t.string :fourth_from, null: false, default: "999"
      t.string :fourth_to, null: false, default: "999"
      t.string :fourth_amount, null: false, default: "0"
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
