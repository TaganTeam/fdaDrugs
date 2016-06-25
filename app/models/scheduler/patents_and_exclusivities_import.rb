class Scheduler::PatentsAndExclusivitiesImport < Scheduler

  protected

    def run_at
      @run_at ||= Time.now.utc
    end

    def create_background_job
      jobs.destroy_all
      jobs.build handler: PatentsAndExclusivitiesImportJob.new.to_yaml, run_at: run_at, scheduled_at: run_at, queue: :default
    end
end
