class AddDeletedAtIndexToPatents < ActiveRecord::Migration
  def change
    add_index :patents, :deleted_at
  end
end
