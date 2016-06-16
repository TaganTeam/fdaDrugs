class AddDrugDetailsColumnsToDrug < ActiveRecord::Migration
  def change
    add_column :drugs, :application_number, :integer
    add_column :drugs, :dosage_form, :string
    add_column :drugs, :strength, :string
    add_column :drugs, :company, :string
    add_column :drugs, :approval_date, :string
  end
end
