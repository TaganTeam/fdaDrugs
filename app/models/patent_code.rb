class PatentCode < ActiveRecord::Base
  has_many :patents
end
