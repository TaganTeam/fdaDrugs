require 'scraper/base_drugs'
require 'scraper/all_app_numbers'
require 'scraper/drug_details'
require 'scraper/new_drugs'
require 'scraper/patents'
require 'scraper/exclusivity_codes'
require 'scraper/patent_use_codes'
require 'scraper/patents_update'


namespace :job do

  # ------ Parse from FILE------ #

  task parse_app_numbers: :environment do
    p 'start'
    Scraper::AllAppNumbers.new.parse_all_app_numbers
    p 'done'
  end

  task parse_exclusivity_codes: :environment do
    p 'start'
    Scraper::ExclusivityCodes.new.parse_exclusivity_codes
    p 'done'
  end

  task parse_patent_codes: :environment do
    p 'start'
    Scraper::PatentUseCodes.new.parse_patent_codes
    p 'done'
  end

  # ------ Parse from FILE------ #

  # ------ Parse from SITE------ #
  task parse_drug_details: :environment do
    p 'start'
    Scraper::DrugDetails.new.parse_drugs
    p 'done'
  end

  task parse_patents_exclusivities: :environment do
    p 'start'
    Scraper::Patents.new.parse_patents_exclusivities
    p 'done'
  end

  task parse_new_drugs: :environment do
    p 'start'
    Scraper::NewDrugs.new.parse_new_drugs
    p 'done'
  end

  task update_patents: :environment do
    p 'start'
    Scraper::PatentsUpdate.new.parse_update_patens
    p 'done'
  end



  # ------ Parse from SITE------ #

end
