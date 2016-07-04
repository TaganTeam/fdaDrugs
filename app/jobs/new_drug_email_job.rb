class NewDrugEmailJob < Struct.new(:mail, :app, :drug)


  def perform
    DrugsMailer.new_drugs(mail, app, drug).deliver
  end

end