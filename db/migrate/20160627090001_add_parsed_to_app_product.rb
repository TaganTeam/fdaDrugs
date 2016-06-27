class AddParsedToAppProduct < ActiveRecord::Migration
  def change
    add_column :app_products, :parsed, :boolean, default: false
  end
end
