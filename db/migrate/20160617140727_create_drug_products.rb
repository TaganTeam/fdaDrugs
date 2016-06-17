class CreateDrugProducts < ActiveRecord::Migration
  def change
    create_table :drug_products do |t|
      t.integer :drug_id
      t.string :product_number
      t.string :strength
      t.datetime :approval_date

      t.timestamps null: false
    end
  end
end
