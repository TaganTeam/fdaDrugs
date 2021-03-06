require 'wombat'
require 'mechanize'

module Scraper
  class DrugDetails < BaseDrugs

    def parse_drugs count_for_iteration=100
      DrugApplication.where(drug_id: nil).first(count_for_iteration).each do |app|
        details_page = get_drug_details_page(app.application_number)

        if details_page.present?

          drug_table = get_target_table(details_page, DRUG_DETAIL_TABLE_INDEX)
          products_table = get_target_table(details_page, DRUG_PRODUCTS_TABLE_INDEX)

          if drug_table.present?
            drug_details = get_drug_details(drug_table)
            drug = save_or_find_drug(drug_details)

            save_drug_app(app, drug_details, drug.id)
            save_products(app, get_products_details(products_table, app.application_number, false)) if products_table.present?
          end
        end
      end
    end


    private


    def save_drug_app app, attr, drug_id
      app.update_attributes(company: attr[:company], approval_date: attr[:approval_date], drug_id: drug_id)
      p "#{app.application_number}--saved"
    rescue Exception => e
        Rails.logger.error "Scraper::DrugDetails ERRROR! Message: #{e}. Drug name: #{attr[:brand_name]}."
    end
  end
end
