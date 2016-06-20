class Drug < ActiveRecord::Base

  has_many :drug_applications

  acts_as_api

  api_accessible :basic do |t|
    t.add :id
    t.add :brand_name
    t.add lambda{ |drug| drug.drug_applications.as_api_response(:light) rescue nil }, as: :apps
    # t.add lambda{|drug| drug.drug_applications.map{ |app| app.application_number}  }, :as => :app_numbers
  end


  # validates :generic_name, presence: true, uniqueness: { scope: :brand_name }

end
