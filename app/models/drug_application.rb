class DrugApplication < ActiveRecord::Base

  acts_as_api

  has_many :app_products
  belongs_to :drug


  validates :application_number, presence: true, uniqueness: true



  api_accessible :light do |t|
    t.add :id
    t.add :application_number
  end

  api_accessible :basic, extend: :light do |t|
    t.add lambda{ |app| app.drug.brand_name }, as: :brand_name
    t.add lambda{ |app| app.drug.generic_name }, as: :generic_name
    t.add :company
    t.add :approval_date
  end

  api_accessible :full_single, extend: :basic do |t|
    t.add lambda{ |app| app.app_products.as_api_response(:basic) rescue nil }, as: :products
  end


end