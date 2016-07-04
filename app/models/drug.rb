class Drug < ActiveRecord::Base

  acts_as_api
  audited

  has_many :drug_applications
  has_many :app_products, through: :drug_applications


  api_accessible :basic do |t|
    t.add :id
    t.add :brand_name
    t.add lambda{ |drug| drug.drug_applications.as_api_response(:light_status) rescue nil }, as: :apps
  end
end
