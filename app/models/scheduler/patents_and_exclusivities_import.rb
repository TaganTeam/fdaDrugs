class Scheduler::PatentsAndExclusivitiesImport < Scheduler
  #Scheduler::PatentsAndExclusivitiesImport.create({frequency: 'every_some_minutes', task: {"per_run_count"=>"1", "parse_timeout"=>"0.5"}})
  protected

    def run_at
      @run_at ||= Time.now.utc
    end

    def create_background_job
      jobs.destroy_all
      jobs.build handler: PatentsAndExclusivitiesImportJob.new.to_yaml, run_at: run_at, scheduled_at: run_at,
                 owner_type: job.owner_type, owner_id: job.owner_id.to_i
    end
end
