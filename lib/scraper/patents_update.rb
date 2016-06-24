module Scraper
  class PatentsUpdate < BaseDrugs

    def parse_update_patents

      [target_patents_data('OB_Rx'), target_patents_data('OB_OTC'), target_patents_data('OB_Disc')].each do |new_patents_data|

        if new_patents_data
          new_patents_data.each do |patent|

            app = DrugApplication.find_by_application_number patent[:app_number]
            product = app.app_products.where(product_number: patent[:product_number])

            if product.empty?
              details_page = get_drug_details_page(patent[:app_number])
              products_table = get_target_table(details_page, 7)
              products = get_products_details(products_table, app.application_number, false)
              attr = products.find {|key| key[:product_number] == patent[:product_number]}

              product = save_products(app, attr)
            end

            Patent.create({
                              app_product_id: product.id,
                              number: patent[:number],
                              patent_expiration: patent[:patent_expiration],
                              drug_substance_claim: patent[:drug_substance_claim],
                              drug_product_claim: patent[:drug_product_claim],
                              patent_code_id: patent[:patent_code_id],
                              delist_requested: patent[:delist_requested]
                          })
          end
        end
      end
      check_for_delelted_patents
    end

    def check_for_delelted_patents
      page = get_data_page('http://www.accessdata.fda.gov/scripts/cder/ob/docs/delist.cfm')

      some_table = get_target_table(page, 0)

      unless some_table.blank?
        #TODO need method some_table is_orx_table?


        delete_patens_data = get_delete_patens_data(rx_table)


        delete_patens_data.each do |item|
          patents = Patent.where(number: item[:delisted_patent])
          if patents
            patents.update_all(deleted_at: Time.now)
          end
        end
      end
    end


    def get_delete_patens_data table
      ary = []

      table.search('tr').each_with_index do |row, i|
        search_results = {}
        unless i == 0
          search_results[:delisted_patent] = clear_name(row.search('td')[4].text)
        end
        ary << search_results
      end
      ary.shift
      ary
    end


    def target_patents_data list
      page = get_new_patents_page('http://www.accessdata.fda.gov/scripts/cder/ob/docs/querynewadds.cfm', list)
      table = get_target_table(page, 0)
      return false if table.blank?

      data = get_patents_data(table, true)
      data
    end

    def get_new_patents_page url, type
      i = get_index type

      page = get_data_page url
      form = page.forms.last
      field = form.radiobuttons_with(name: /table1/)[i]
      field.check
      sleep 0.5
      new_page = form.submit
      new_page
    end

    def get_index item
      case item
        when 'OB_Rx'
          index = 0
        when 'OB_OTC'
          index = 1
        when 'OB_Disc'
          index = 2
      end
      index
    end
  end
end