class NewDrugsEmptyEmailsJob

  def perform
    User.find_each do |user|
      DrugsMailer.no_drugs(user).deliver_now
    end
  end
end