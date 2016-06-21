class Patent < ActiveRecord::Base

  belongs_to :app_product
  belongs_to :patent_code
end
