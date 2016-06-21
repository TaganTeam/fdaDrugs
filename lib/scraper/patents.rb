module Scraper
  class Patents < BaseDrugs

    def parse_patents_exclusivities
      # DrugApplication.where(application_number: '022334').each do |app|
      DrugApplication.all.each do |app|
        app.app_products.where(patent_status: true).each do |product|
          page = get_data_page("http://www.accessdata.fda.gov/scripts/cder/ob/docs/patexclnew.cfm?Appl_No=#{app.application_number}&Product_No=#{product.product_number}&table1=OB_Rx")

          patents_table = get_patents_table(page)
          exclusivity_table = get_exclusivity_table(page)

          patents_data = get_patents_data(patents_table)
          exclusivity_data = get_exclusivity_data(exclusivity_table)

          save_patents_data(product, patents_data)
          save_exclusivity_data(product, exclusivity_data)
        end
      end
    end


    def get_patents_data table
      ary = []

      table.search('tr').each_with_index do |row, i|
        search_results = {}
        unless i == 0
          search_results[:number] = row.search('td')[2].text
          search_results[:patent_expiration] = row.search('td')[3].text.strip
          search_results[:drug_substance_claim] = row.search('td')[4].text.strip
          search_results[:drug_product_claim] = row.search('td')[5].text.strip
          search_results[:patent_use_code] = clear_name(row.search('td')[6].text)
          search_results[:delist_requested] = clear_name(row.search('td')[7].text)
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
          search_results[:exclusivity_code] = clear_name(row.search('td')[2].text)
          search_results[:exclusivity_expiration] = row.search('td')[3].text.strip
        end
        ary << search_results
      end
      ary.shift
      ary
    end


    private

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
  end
end