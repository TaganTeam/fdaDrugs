require 'wombat'
require 'mechanize'

module Scraper
  class DrugDetails < BaseDrugs

    def parse_drugs
      Drug.all.each do |drug|
        page = get_page(drug.application_number)
        data_table = page.search('#user_provided table')
        count_tables = data_table.length

        if data_table.blank?
          drug.update_column(:discontinued, true)
        else

          if count_tables > 1
            count_tables.times do |i|
              i == 0 ? save_drug_details(drug, get_drug_details(data_table[i])) : save_drug_products(drug, get_drug_details(data_table[i]))
            end
          else
            save_drug_details(drug, get_drug_details(data_table))
          end
        end
      end
    end

    def get_drug_details data_table
      search_results = {}

      data_table.search('tr').each do |row|
        key = row.search('span.fontsize')[0].text.downcase.delete(':').gsub(/\s+/, '') rescue ''
        val = row.search('span.fontsize')[1].text rescue ''

        search_results[:brand_name] = val if key == 'proprietaryname'
        search_results[:generic_name] = val if key == 'activeingredient'
        search_results[:product_number] = val if key == 'productnumber'
        search_results[:dosage_form] = val if key == 'dosageform;route'
        search_results[:strength] = val if key == 'strength'
        search_results[:company] = val if key == 'applicant'
        search_results[:approval_date] = val if key == 'approvaldate'
      end
      search_results
    end

    def get_page application_number
      mechanize = Mechanize.new
      mechanize.get("http://www.accessdata.fda.gov/scripts/cder/ob/docs/obdetail.cfm?Appl_No=#{application_number}&TABLE1=OB_Rx")
    end


    private

    def save_drug_details drug, attr
      drug.update_attributes attr
    rescue Exception => e
        Rails.logger.error "Scraper::DrugDetails ERRROR! Message: #{e}. Drug name: #{attr[:brand_name]}."
    end

    def save_drug_products drug, attr
      drug.drug_products.create(product_number: attr[:product_number],  strength: attr[:strength], approval_date: attr[:approval_date])
    rescue Exception => e
      Rails.logger.error "Scraper::DrugDetails ERRROR! Message: #{e}. Drug name: #{attr[:brand_name]}. Product number: #{attr[:product_number]}"
    end
  end
end