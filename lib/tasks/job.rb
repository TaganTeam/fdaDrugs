require 'scraper'

namespace :job do

  task parse_drugs: :environment do
    p 'start'
    Scraper::Drugs.new.parse
    p 'done'
  end
end
