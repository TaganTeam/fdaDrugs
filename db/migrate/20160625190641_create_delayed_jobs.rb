class CreateDelayedJobs < ActiveRecord::Migration
  def change
    create_table :schedulers do |t|
      t.string   "type",                           null: false
      t.text     "task",                           null: false
      t.time     "time"
      t.string   "day"
      t.string   "frequency"
      t.datetime "deleted_at"

      t.timestamps null: false
    end
  end
end
