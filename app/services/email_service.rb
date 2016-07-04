class EmailService

  def initialize; end


  def new_drugs_info app
    from = 'bshc_piv <no-reply@bshc_piv.com>'
    subject = 'Add new Drug'
    drug = app.drug
    User.find_each do |user|
      Email::NewDrugsEmail.create(user_id: user.id, to: user.email, from: from, subject: subject, status: 0, app: app, drug: drug)

    end
  end








end