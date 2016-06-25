class AddColumnDeletedAtToPatents < ActiveRecord::Migration
  def change
    add_column :patents, :deleted_at, :datetime
  end
end
