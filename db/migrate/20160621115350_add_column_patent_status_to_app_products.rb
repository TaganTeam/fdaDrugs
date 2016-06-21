class AddColumnPatentStatusToAppProducts < ActiveRecord::Migration
  def change
    add_column :app_products, :patent_status, :boolean
  end
end
