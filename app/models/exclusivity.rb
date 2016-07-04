class Exclusivity < ActiveRecord::Base

  acts_as_api
  audited

  belongs_to :app_product
  belongs_to :exclusivity_code


  api_accessible :basic do |t|
    t.add :exclusivity_code_id
    t.add lambda{ |exclusive| exclusive.exclusivity_code.code rescue nil}, as: :exclusivity_code
    t.add :exclusivity_expiration
  end
end
