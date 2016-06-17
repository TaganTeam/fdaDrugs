class AddColumnDiscontinuedToDrugs < ActiveRecord::Migration
  def change
    add_column :drugs, :discontinued, :boolean, default: false
  end
end
