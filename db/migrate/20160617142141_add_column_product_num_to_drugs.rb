class AddColumnProductNumToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :product_number, :string
  end
end
