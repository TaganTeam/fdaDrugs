require 'rails_helper'
require 'scraper/base_drugs'
require 'scraper/new_drugs'


describe Scraper::NewDrugs do
  context 'empty and' do
    it 'should be no results' do
      VCR.use_cassette('empty_table') do
        expect(Scraper::NewDrugs.new.parse_new_drugs).to eq('Your selected month and year did not return any results.')
      end
    end
  end

  context 'exists and' do
    it 'should be at least one app and product' do
      VCR.use_cassette('new_drugs') do
        Scraper::NewDrugs.new.parse_new_drugs
        expect(DrugApplication.all).not_to be_empty
        expect(AppProduct.all).not_to be_empty
      end
    end
  end
end