class AppProduct < ActiveRecord::Base

  acts_as_api

  has_many :patents
  has_many :exclusivities
  belongs_to :drug_application


  api_accessible :basic do |t|
    t.add :strength
    t.add :dosage
    t.add :market_status
  end
end
