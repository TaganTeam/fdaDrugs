class CreateAppProducts < ActiveRecord::Migration
  def change
    create_table :app_products do |t|
      t.integer :drug_application_id
      t.string :strength
      t.string :dosage
      t.string :market_status
      t.string :product_number

      t.timestamps null: false
    end
  end
end
