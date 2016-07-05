class NewPatentsEmailsJob < Struct.new(:new_patents)

  def perform
    User.find_each do |user|
      PatentsMailer.new_patents(new_patents, user).deliver_now
    end
  end
end