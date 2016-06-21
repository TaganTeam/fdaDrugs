class CreateExclusivityCodes < ActiveRecord::Migration
  def change
    create_table :exclusivity_codes do |t|
      t.string :code
      t.string :definition

      t.timestamps null: false
    end
  end
end
