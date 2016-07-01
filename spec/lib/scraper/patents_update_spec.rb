require 'rails_helper'
require 'scraper/base_drugs'
require 'scraper/patents_update'


describe Scraper::PatentsUpdate do
  it 'should be new patents' do
    VCR.use_cassette('new_patents') do
      Scraper::PatentsUpdate.new.parse_update_patents
      expect(Patent.all).not_to be_empty
    end
  end
end