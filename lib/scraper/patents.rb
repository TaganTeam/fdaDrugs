module Scraper
  class Patents < BaseDrugs

    def parse_patents_exclusivities
      DrugApplication.all.each do |app|
        app.app_products.where(patent_status: true).each do |product|
          save_patent_exclusivity_for(app.application_number, product.product_number)
        end
      end
    end
  end
end