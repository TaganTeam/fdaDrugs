class Scheduler::DrugDetailsImport < Scheduler

  protected

    def create_background_job
      jobs.destroy_all
      jobs.build handler: DrugDetailsImportJob.new.to_yaml, run_at: run_at, scheduled_at: run_at
    end
end
