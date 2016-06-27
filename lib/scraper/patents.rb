module Scraper
  class Patents < BaseDrugs

    def parse_patents_exclusivities cnt = 100
      AppProduct.where(patent_status: true, parsed: false).first(cnt).each do |product|
        save_patent_exclusivity_for(product.drug_application.application_number, product)
      end
    end
  end
end
