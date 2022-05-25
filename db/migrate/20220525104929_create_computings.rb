class CreateComputings < ActiveRecord::Migration[5.2]
  def change
    create_table :computings do |t|

      t.timestamps
    end
  end
end
