class CreatePatents < ActiveRecord::Migration
  def change
    create_table :patents do |t|
      t.integer :app_product_id
      t.integer :patent_code_id
      t.string :number
      t.datetime :patent_expiration
      t.string :drug_substance_claim
      t.string :drug_product_claim
      t.string :delist_requested

      t.timestamps null: false
    end
  end
end