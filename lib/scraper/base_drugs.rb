require 'wombat'
require 'mechanize'

module Scraper
  class BaseDrugs

    attr_accessor :status

    def get_data_page url
      sleep 0.5
      mechanize = Mechanize.new
      page = mechanize.get(url)
      page
    end

    def get_drug_details data_table
      search_results = {}

      data_table.search('tr').each do |row|
        key = row.search('td.details_table')[0].text.downcase.gsub(/\s+/, '') rescue ''
        val = row.search('td.details_table')[1].text rescue ''

        search_results[:brand_name] = val if key == 'drugname(s)'
        search_results[:application_number] = val.gsub(/[^\d]/, '') if key == 'fdaapplicationno.'
        search_results[:generic_name] = val if key == 'activeingredient(s)'
        search_results[:company] = val if key == 'company'
        search_results[:approval_date] = val if key == 'originalapprovalortentativeapprovaldate'
      end
      search_results
    end

    def get_drug_table page
      table = page.search('#user_provided table')[4]
      table
    end

    def get_products_table page
      table = page.search('#user_provided table')[7]
      table
    end

    def get_patents_table page
      table = page.search('#user_provided table')[0]
      table
    end

    def get_exclusivity_table page
      table = page.search('#user_provided table')[1]
      table
    end

    def get_products_details products_table, appl_no, new_drug
      ary = []
      products_table.search('tr').each_with_index do |row, i|
        products = {}

        row.search('td.product_table').each_with_index do |item, index|
          case index
            when 2
              products[:strength] = item.text
            when 3
              products[:dosage] = item.text
            when 4
              products[:market_status] = item.text
          end
        end
        products[:product_number] = get_product_number(i, appl_no, new_drug)
        products[:patent_status] = get_patent_status(appl_no, products[:product_number])
        ary << products
      end
      ary.shift
      ary
    end

    def get_product_number index, appl_no, new_drug
      if new_drug
        "0#{index < 9 ? '0' : index + 1}#{index}"

      else
        ary = []
        File.open("lib/scraper/data_files/Product.txt") do |f|
          f.each_line do |line|
            if line.match(/#{appl_no}/)
              ary << line.gsub(/\r|\n|\t/,'')[6..8]
            end
          end
        end
        ary[index-1]
      end
    end

    def get_patent_status appl_no, product_number
      sleep 0.5
      page = get_data_page("http://www.accessdata.fda.gov/scripts/cder/ob/docs/patexclnew.cfm?Appl_No=#{appl_no}&Product_No=#{product_number}&table1=OB_Rx")
      get_patents_table(page).nil? ? 0 : 1
    end

    private

    def save_or_find_drug drug_details
      Drug.find_or_create_by(brand_name: drug_details[:brand_name], generic_name: drug_details[:generic_name])
    end

    def save_products drug_app, attr
      drug_app.app_products.create(attr)
    rescue Exception => e
      Rails.logger.error "Scraper::DrugDetails ERRROR! Message: #{e}. Drug application number: #{drug_app.application_number}."
    end

    def clear_name name
      name.gsub(/\r|\n|\t/,'').gsub(/\s+/, '')
    end

  end
end