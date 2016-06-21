class Exclusivity < ActiveRecord::Base

  belongs_to :app_product
  belongs_to :exclusivity_code
end
