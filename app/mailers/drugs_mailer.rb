class DrugsMailer < ActionMailer::Base

  def new_drugs(new_apps, user)
    @new_apps = new_apps
    Rails.logger.info
    mail(to: user.email, subject: 'New drug' )
  end


  def no_drugs user
    mail(to: user.email, subject: 'No drug' )
  end
end