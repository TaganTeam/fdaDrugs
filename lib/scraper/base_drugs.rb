require 'wombat'
require 'mechanize'

module Scraper
  class BaseDrugs

    def get_data_page url
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

    def get_products_details products_table, appl_no
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
        products[:product_number] = get_product_number(i, appl_no)
        ary << products
      end
      ary.shift
      ary
    end

    def get_product_number index, appl_no
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

    private

    def clear_name name
      name.gsub(/\r|\n|\t/,'').gsub(/\s+/, ' ')
    end

  end
end