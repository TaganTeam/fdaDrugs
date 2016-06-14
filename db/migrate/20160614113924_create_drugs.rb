class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.string :brand_name
      t.string :generic_name

      t.timestamps null: false
    end
  end
end
