require 'wombat'
require 'mechanize'

module Scraper
  class DrugDetails < BaseDrugs

    def parse_drug_details

      # all_drugs = Drug.all

      all_drugs = Drug.where id: 771


      all_drugs.each do |drug|
        page = get_page(drug.brand_name)

        page.search('.details_table strong').each_with_index do |item, index|
          case index
            when 3
              drug.update_column(:application_number, item.text.scan(/\d+/).first.to_i)
            when 7
              drug.update_column(:company, item.text)
            when 9
              drug.update_column(:approval_date, item.text)
          end
        end

        page.search('.product_table').each_with_index do |item, index|
          case index
            when 2
              drug.update_column(:strength, item.text)
            when 3
              drug.update_column(:dosage_form, item.text)
          end
        end
      end
    end


    def get_page brand_name
      mechanize = Mechanize.new
      mechanize.get("http://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm?fuseaction=Search.Overview&DrugName=#{brand_name}")
    end

  end
end