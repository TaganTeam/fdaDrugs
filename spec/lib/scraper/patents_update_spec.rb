require 'rails_helper'
require 'scraper/base_drugs'
require 'scraper/patents_update'


describe Scraper::PatentsUpdate do
  it 'should be new patents' do
    FactoryGirl.create(:drug_application)

    VCR.use_cassette('new_patents') do
      Scraper::PatentsUpdate.new.parse_update_patents(2)
      expect(Patent.all).not_to be_empty
    end
  end
end
