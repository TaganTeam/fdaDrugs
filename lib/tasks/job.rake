require 'scraper/base_drugs'
require 'scraper/all_app_numbers'
require 'scraper/drug_details'
require 'scraper/new_drugs'

namespace :job do
  task parse_app_numbers: :environment do
    p 'start'
    Scraper::AllAppNumbers.new.parse_all_app_numbers
    p 'done'
  end

  task parse_drug_details: :environment do
    p 'start'
    Scraper::DrugDetails.new.parse_drugs
    p 'done'
  end

  task parse_new_drugs: :environment do
    p 'start'
    Scraper::NewDrugs.new.parse_new_drugs
    p 'done'
  end

end
