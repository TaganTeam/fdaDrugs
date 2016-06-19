class DrugApplication < ActiveRecord::Base

  has_many :app_products
  has_one :drug
end
