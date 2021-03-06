class PatentsUpdatesImportJob

  def before(job)
    @task_id = job.owner_id
  end

  def success(job)
    add_next_job job
  end

  def max_attempts
    return 1
  end

  def perform
    Scraper::PatentsUpdate.new(parse_timeout).parse_update_patents
  end

  protected

  def task_id
    @task_id.to_i
  end

  def parse_timeout
    @parse_timeout ||= task.parse_timeout
  end

  def task
    @task ||= Scheduler::PatentsUpdatesImport.find(task_id)
  end

  def add_next_job job
    run_at = Time.now.utc + task.per_run_count.minutes
    Delayed::Job.create handler: PatentsUpdatesImportJob.new.to_yaml, run_at: run_at, scheduled_at: run_at,
                        owner_type: job.owner_type, owner_id: job.owner_id.to_i
  end

end
