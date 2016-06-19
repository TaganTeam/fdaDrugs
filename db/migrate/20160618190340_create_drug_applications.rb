class CreateDrugApplications < ActiveRecord::Migration
  def change
    create_table :drug_applications do |t|
      t.integer :drug_id
      t.string :application_number
      t.string :company
      t.datetime :approval_date

      t.timestamps null: false
    end
  end
end
