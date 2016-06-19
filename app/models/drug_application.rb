class DrugApplication < ActiveRecord::Base

  has_many :app_products
  has_one :drug


  validates :application_number, presence: true, uniqueness: true
end
