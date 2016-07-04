class Email::NewDrugsEmail < Email

  protected

  def create_job
    jobs.destroy_all
    jobs.create handler: NewDrugEmailJob.new(current_mail, current_app, current_drug).to_yaml, run_at: run_at, scheduled_at: run_at,
               owner_type: 'Email', owner_id: self.id
  end
end