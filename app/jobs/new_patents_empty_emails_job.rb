class NewPatentsEmptyEmailsJob

  def perform
    User.find_each do |user|
      PatentsMailer.no_patents(user).deliver_now
    end
  end
end