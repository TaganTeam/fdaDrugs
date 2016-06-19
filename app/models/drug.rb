class Drug < ActiveRecord::Base

  has_many :drug_applications

  acts_as_api

  api_accessible :basic do |t|
    t.add :id
    t.add :brand_name
    t.add :generic_name
  end

  # validates :generic_name, presence: true, uniqueness: { scope: :brand_name }

end
