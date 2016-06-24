require 'wombat'
require 'mechanize'

module Scraper
  class DrugDetails < BaseDrugs

    def parse_drugs
      DrugApplication.where(drug_id: nil).each do |app|
        details_page = get_drug_details_page(app.application_number)

        if details_page.present?

          drug_table = get_target_table(details_page, 4)
          products_table = get_target_table(details_page, 7)

          drug_details = get_drug_details(drug_table)
          drug = save_or_find_drug(drug_details)

          save_drug_app(app, drug_details, drug.id)
          save_products(app, get_products_details(products_table, app.application_number, false))
        end
      end
    end



    def is_drug_details? page
      page.at('#user_provided table td.product_table a').nil?
    end

    def get_another_page page
      sleep 0.5
      text = page.at('#user_provided table td.product_table a').text
      link = page.link_with(text: text)
      some_page = link.click
      some_page
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