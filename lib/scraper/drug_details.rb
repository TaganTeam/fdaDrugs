require 'wombat'
require 'mechanize'

module Scraper
  class DrugDetails < BaseDrugs

    def parse_drugs
      DrugApplication.all.each do |app|
        details_page = get_drug_details_page(app.application_number)

        drug_table = get_drug_table(details_page)
        products_table = get_products_table(details_page)


        drug_details = get_drug_details(drug_table)
        drug = save_or_find_drug(drug_details)

        save_drug_app(app, drug_details, drug.id)
        save_products(app, get_products_details(products_table, app.application_number, false))
      end
    end

    def get_drug_details_page appl_no
      page = get_data_page('https://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm')

      sleep 1
      form = page.form('displaysearch')
      form['searchTerm'] = appl_no
      new_page = form.submit

      sleep 0.5

      if new_page.at('#user_provided table td.product_table a').nil?
        drug_details_page = new_page
      else
        text = new_page.at('#user_provided table td.product_table a').text
        link = new_page.link_with(text: text)
        drug_details_page = link.click
      end
      drug_details_page
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