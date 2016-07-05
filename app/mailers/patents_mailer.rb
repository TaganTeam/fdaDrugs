class PatentsMailer < ActionMailer::Base

  def new_patents(patents, user)
    @updated_patents = patents
    Rails.logger.info
    mail(to: user.email, subject: 'New patents' )
  end


  def no_patents user
    mail(to: user.email, subject: 'No patents' )
  end
end