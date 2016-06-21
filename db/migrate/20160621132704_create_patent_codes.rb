class CreatePatentCodes < ActiveRecord::Migration
  def change
    create_table :patent_codes do |t|
      t.string :code
      t.string :definition

      t.timestamps null: false
    end
  end
end
