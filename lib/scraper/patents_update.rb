module Scraper
  class PatentsUpdate < BaseDrugs

    def parse_update_patens

      ob_rx_page = get_new_patents_page('http://www.accessdata.fda.gov/scripts/cder/ob/docs/querynewadds.cfm', 'OB_Rx')
      ob_rx_table = get_target_table(ob_rx_page, 0)
      new_patents_data = get_patents_data(ob_rx_table, true)

      p "---new_patents_data---#{new_patents_data}"


      new_patents_data.each do |patent|

        app = DrugApplication.find_by_application_number patent[:app_number]
        new_number = app.app_products.where(product_number: patent[:product_number])

        if new_number.empty?
          details_page = get_drug_details_page(patent[:app_number])
          products_table = get_target_table(details_page, 7)
          attr = get_products_details(products_table, app.application_number, false)

          p "---attr---#{attr}"

          # save_products(app, attr)

        end



        new_db_patent = Patent.create({
                                   app_product_id: new_db_patent.app_product.id,
                                   number: patent[:number],
                                   patent_expiration: patent[:patent_expiration],
                                   drug_substance_claim: patent[:drug_substance_claim],
                                   drug_product_claim: patent[:drug_product_claim],
                                   patent_code_id: patent[:patent_code_id],
                                   delist_requested: patent[:delist_requested]
                                  })



      end



    end

    def get_new_patents_page url, type
      i = get_index type

      page = get_data_page url
      form = page.forms.last
      field = form.radiobuttons_with(name: /table1/)[i]
      field.check
      new_page = form.submit
      new_page
    end

    def get_index item
      case item
        when 'OB_Rx'
          index = 0
        when 'OB_Rx'
          index = 1
        when 'OB_Rx'
          index = 2
      end
      index
    end




  end
end