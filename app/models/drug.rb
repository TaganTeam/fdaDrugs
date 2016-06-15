class Drug < ActiveRecord::Base
  acts_as_api

  api_accessible :basic do |t|
    t.add :id
    t.add :brand_name
    t.add :generic_name
  end
end
