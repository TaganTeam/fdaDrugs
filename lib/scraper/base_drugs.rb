require 'wombat'
require 'mechanize'

module Scraper
  class BaseDrugs

    DRUG_DETAIL_TABLE_INDEX = 4
    DRUG_PRODUCTS_TABLE_INDEX = 7

    attr_accessor :status

    def initialize parse_timeout=0.5
      @parse_timeout = parse_timeout
    end

    def get_data_page url
      sleep @parse_timeout
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

    def get_target_table page, i
      table = page.search('#user_provided table')[i]
      table
    end

    def get_drug_details_page appl_no, attempt=1
      p "---attempt--#{attempt}"
      page = get_data_page('https://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm')

      sleep @parse_timeout
      form = page.form('displaysearch')
      form['searchTerm'] = appl_no
      new_page = form.submit

      sleep @parse_timeout

      if is_drug_details? new_page
        drug_details_page = new_page
      else
        some_page = get_another_page(new_page)
        drug_details_page = is_drug_details?(some_page) ? some_page : get_another_page(some_page)
      end
      drug_details_page

    rescue Exception => e
      Rails.logger.error "Scraper::DrugDetails ERRROR! Message: #{e}. Application number #{appl_no}"

      if attempt >= 5
        Rails.logger.error "Scraper::DrugDetails ERRROR! Message: #{e}. Application number #{appl_no}. Attempt more than 5. Application was skipped."
        false
      else
        attempt += 1
        sleep @parse_timeout
        get_drug_details_page appl_no, attempt
      end
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
        products[:patent_status] = get_patent_status(appl_no, products[:product_number], products[:market_status])
        ary << products
      end
      ary.shift
      ary
    end

    def is_drug_details? page
      node = get_target_table(page, 3)
      str = clear_name(node.text) rescue false
      (str == 'DrugDetails') ? true : false
    end

    def get_another_page page
      sleep @parse_timeout
      text = page.at('#user_provided table td.product_table a').text
      link = page.link_with(text: text)
      some_page = link.click
      some_page
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

    def get_patent_status appl_no, product_number, market_status
      sleep @parse_timeout
      list = get_patent_list market_status
      page = get_data_page("http://www.accessdata.fda.gov/scripts/cder/ob/docs/patexclnew.cfm?Appl_No=#{appl_no}&Product_No=#{product_number}&table1=#{list}")
      get_target_table(page, 0).nil? ? 0 : 1
    end


    def save_patent_exclusivity_for appl_no, product
      list = get_patent_list product.market_status
      p "http://www.accessdata.fda.gov/scripts/cder/ob/docs/patexclnew.cfm?Appl_No=#{appl_no}&Product_No=#{product.product_number}&table1=#{list}"
      page = get_data_page("http://www.accessdata.fda.gov/scripts/cder/ob/docs/patexclnew.cfm?Appl_No=#{appl_no}&Product_No=#{product.product_number}&table1=#{list}")
      
      begin
        first_table = get_target_table(page, 0)
        second_table = get_target_table(page, 1)

        unless second_table.nil?
          exclusivity_data = get_exclusivity_data(second_table)
          save_exclusivity_data(product, exclusivity_data)

          patents_data = get_patents_data(first_table, false)
          save_patents_data(product, patents_data)
        else

          if exclusivity_table? first_table
            exclusivity_data = get_exclusivity_data(first_table)
            save_exclusivity_data(product, exclusivity_data)
          else
            patents_data = get_patents_data(first_table, false)
            save_patents_data(product, patents_data)
          end
        end

        product.update_attributes(parsed: true)

      rescue Exception => e
        Rails.logger.error "Scraper::Patents ERROR! Message: #{e}. Application number #{appl_no}. Product number #{product.product_number}"
      end
    end

    def exclusivity_table? table
      table.text.match(/Exclusivity Code/).nil? ? false : true
    end


    def get_patents_data table, is_update
      ary = []

      table.search('tr').each_with_index do |row, i|
        search_results = {}
        unless i == 0
          if is_update
            search_results[:app_number] = clear_name(row.search('td')[0].text.gsub(/[^\d]/, '')).strip
            search_results[:product_number] = clear_name(row.search('td')[1].text).strip
          end
          search_results[:number] = row.search('td')[ is_update ? 3 : 2].text
          search_results[:patent_expiration] = row.search('td')[is_update ? 4 : 3].text.strip
          search_results[:drug_substance_claim] = row.search('td')[is_update ? 5 : 4].text.strip
          search_results[:drug_product_claim] = row.search('td')[is_update ? 6 : 5].text.strip
          search_results[:patent_code_id] = PatentCode.find_by_code(clear_name(row.search('td')[is_update ? 7 : 6].text)).id rescue nil
          search_results[:delist_requested] = clear_name(row.search('td')[is_update ? 8 : 7].text)
        end
        ary << search_results
      end
      ary.shift
      ary
    end

    def get_exclusivity_data table
      ary = []

      table.search('tr').each_with_index do |row, i|
        search_results = {}
        unless i == 0
          search_results[:exclusivity_code_id] = ExclusivityCode.find_by_code(clear_name(row.search('td')[2].text)).id rescue nil
          search_results[:exclusivity_expiration] = row.search('td')[3].text.strip
        end
        ary << search_results
      end
      ary.shift
      ary
    end

    def get_patent_list market_status
      case market_status
        when "Prescription "
          list = 'OB_Rx'
        when "Discontinued "
          list = 'OB_Disc'
        else
          list = 'OB_OTC'
      end
      list
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

    def save_patents_data product, patents_data
      product.patents.create(patents_data)
      p "----#{product.drug_application.application_number}-----#{product.product_number}--saved"
    rescue Exception => e
      Rails.logger.error "Scraper::Patents ERRROR! Message: #{e}. Drug application id: #{product.drug_application_id}. Product number: #{product.product_number}."
    end

    def save_exclusivity_data product, exclusivity_data
      product.exclusivities.create(exclusivity_data)
      p "----#{product.drug_application.application_number}-----#{product.product_number}--exclusivity saved"
    rescue Exception => e
      Rails.logger.error "Scraper::Patents ERRROR! Message: #{e}. Drug application id: #{product.drug_application_id}. Product number: #{product.product_number}."
    end

    def clear_name name
      name.gsub(/\r|\n|\t/,'').gsub(/\s+/, '')
    end

    def clear_symbols name
      name.gsub(/\r|\n|\t/,'')
    end

  end
end
