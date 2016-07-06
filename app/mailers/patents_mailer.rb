class PatentsMailer < ActionMailer::Base
  default from: 'bshc_piv <no-reply@bshc_piv.com>'

  def new_patents(patents, user)
    @updated_patents = patents
    Rails.logger.info
    mail(to: user.email, subject: 'New patents' )
  end


  def no_patents user
    mail(to: user.email, subject: 'No patents' )
  end
end