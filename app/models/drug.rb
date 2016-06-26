class Drug < ActiveRecord::Base

  has_many :drug_applications
  has_many :app_products, through: :drug_applications

  acts_as_api

  api_accessible :basic do |t|
    t.add :id
    t.add :brand_name
    t.add :has_patent
    t.add lambda{ |drug| drug.drug_applications.as_api_response(:light_status) rescue nil }, as: :apps
  end


  def has_patent
    drug_applications.joins(:app_products).where("app_products.category_id = ?", self.company.id)
  end
end
