class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :from
      t.string :to
      t.string :subject
      t.integer :status

      t.timestamps null: false
    end
  end
end
