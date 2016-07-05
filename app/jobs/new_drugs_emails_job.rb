class NewDrugsEmailsJob < Struct.new(:new_apps)

  def perform
    User.find_each do |user|
      DrugsMailer.new_drugs(new_apps, user).deliver_now
    end
  end
end