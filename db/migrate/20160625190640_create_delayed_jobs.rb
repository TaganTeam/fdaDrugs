class CreateDelayedJobs < ActiveRecord::Migration
  def change
    create_table :delayed_jobs do |t|
      t.integer  "priority",     default: 0, null: false
      t.integer  "attempts",     default: 0, null: false
      t.text     "handler",                  null: false
      t.text     "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string   "locked_by"
      t.string   "queue"

      t.timestamps null: false
    end
  end
end
