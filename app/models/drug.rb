class Drug < ActiveRecord::Base

  has_many :drug_applications

  acts_as_api

  api_accessible :basic do |t|
    t.add :id
    t.add :brand_name
    t.add lambda{ |drug| drug.drug_applications.as_api_response(:light_status) rescue nil }, as: :apps
  end
end
