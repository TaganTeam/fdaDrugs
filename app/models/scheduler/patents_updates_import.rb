class Scheduler::PatentsUpdatesImport < Scheduler
 #Scheduler::PatentsUpdatesImport.create({frequency: 'every_some_minutes', task: {"per_run_count"=>"1440
 # ", "parse_timeout"=>"0.5"}})
  protected

    def create_background_job
      jobs.destroy_all
      jobs.build handler: PatentsUpdatesImportJob.new.to_yaml, run_at: run_at, scheduled_at: run_at,
                 owner_type: 'Scheduler', owner_id: self.id
    end
end
