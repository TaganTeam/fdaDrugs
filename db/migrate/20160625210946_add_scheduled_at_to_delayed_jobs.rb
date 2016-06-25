class AddScheduledAtToDelayedJobs < ActiveRecord::Migration
  def change
    add_column :delayed_jobs, :scheduled_at, :datetime

    add_column :delayed_jobs, :owner_type, :string
    add_column :delayed_jobs, :owner_id, :integer, foreign_key: false
  end
end
