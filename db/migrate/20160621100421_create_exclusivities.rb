class CreateExclusivities < ActiveRecord::Migration
  def change
    create_table :exclusivities do |t|
      t.integer :app_product_id
      t.integer :exclusivity_code_id
      t.datetime :exclusivity_expiration

      t.timestamps null: false
    end
  end
end
