class NewPatentsEmailsJob < Struct.new(:patents, :is_new_patents)

  def perform
    User.find_each do |user|
      is_new_patents ? PatentsMailer.new_patents(patents, user).deliver_now : PatentsMailer.deleted_patents(patents, user).deliver_now
    end
    patents.each {|patent| patent.destroy} unless is_new_patents
  end
end