class Patent < ActiveRecord::Base

  acts_as_api

  belongs_to :app_product
  belongs_to :patent_code


  api_accessible :basic do |t|
    t.add :patent_code_id
    t.add lambda{ |patent| patent.patent_code.code rescue nil}, as: :patent_code
    t.add :number
    t.add :patent_expiration
    t.add :drug_substance_claim
    t.add :drug_product_claim
    t.add :delist_requested
  end


  validates :number, presence: true, uniqueness: {scope: :app_product_id}

end
