class Patent < ActiveRecord::Base

  acts_as_api
  acts_as_paranoid
  audited

  belongs_to :app_product
  belongs_to :patent_code

  before_create :check_uniq


  api_accessible :basic do |t|
    t.add :patent_code_id
    t.add lambda{ |patent| patent.patent_code.code rescue nil}, as: :patent_code
    t.add :number
    t.add :patent_expiration
    t.add :drug_substance_claim
    t.add :drug_product_claim
    t.add :delist_requested
  end



  private

  def check_uniq
    Patent.joins(:app_product).where('patents.number = ?', number).where('app_products.product_number = ?', app_product.product_number).blank?
  end

end
