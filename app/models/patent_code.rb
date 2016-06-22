class PatentCode < ActiveRecord::Base

  acts_as_api

  has_many :patents


  api_accessible :basic do |t|
    t.add :code
    t.add :definition
  end
end
