module Scraper
  class PatentsUpdate < BaseDrugs

    attr_accessor :new_patent

    def parse_update_patents limit=1000
      new_patents = []
      [
        target_patents_data('OB_Rx'),
        target_patents_data('OB_OTC'),
        target_patents_data('OB_Disc')
      ].each do |new_patents_data|
        if new_patents_data
          new_patents_data.each_with_index do |patent, index|
            if patent[:app_number].present? && index < limit
              app = DrugApplication.find_by_application_number patent[:app_number]
              if app
                product = app.app_products.where(product_number: patent[:product_number]).first

                if product.blank?
                  details_page = get_drug_details_page(patent[:app_number])
                  products_table = get_target_table(details_page, DRUG_PRODUCTS_TABLE_INDEX)
                  products = get_products_details(products_table, app.application_number, false)
                  attr = products.find {|key| key[:product_number] == patent[:product_number]}

                  product = save_products(app, attr)
                end

                save_patent(product.id, patent)

                if new_patent? @patent
                  new_patents << @patent
                end
              end
            end
          end
        end
      end

      unless new_patents.empty?
        send_patents_emails(new_patents)
      else
        send_no_patents_emails
      end

      check_for_deleted_patents
    end

    def check_for_deleted_patents
      sleep @parse_timeout
      page = get_data_page('http://www.accessdata.fda.gov/scripts/cder/ob/docs/delist.cfm')

      first_table = get_target_table(page, 0)
      second_table = get_target_table(page, 1)
      third_table = get_target_table(page, 2)

      unless first_table.blank?

        first_deleted_patens = get_delete_patens_data(first_table)
        mark_patent_as_deleted(first_deleted_patens)

        unless second_table.blank?
          second_deleted_patens = get_delete_patens_data(second_table)
          mark_patent_as_deleted(second_deleted_patens)
        end

        unless third_table.blank?
          third_deleted_patens = get_delete_patens_data(third_table)
          mark_patent_as_deleted(third_deleted_patens)
        end

      end
    end

    def mark_patent_as_deleted data
      delisted_patents = []

      data.each do |item|
        patent = Patent.joins(:app_product).where('patents.number = ? AND app_products.product_number = ?', item[:delisted_patent], item[:prod_number]).first
        delisted_patents << patent unless patent.blank?
      end
      Delayed::Job.enqueue NewPatentsEmailsJob.new(delisted_patents, false) unless delisted_patents.empty?
    end


    def get_delete_patens_data table
      ary = []

      table.search('tr').each_with_index do |row, i|
        search_results = {}
        unless i == 0
          search_results[:prod_number] = clear_name(row.search('td')[1].text)
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
      sleep @parse_timeout
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

    def new_patent? patent
      patent.persisted?
    end


    def send_patents_emails(new_patents)
      Delayed::Job.enqueue NewPatentsEmailsJob.new(new_patents, true)
    end

    def send_no_patents_emails
      Delayed::Job.enqueue NewPatentsEmptyEmailsJob.new
    end

    private

    def save_patent product_id, attr
      @patent = Patent.create({
                        app_product_id: product_id,
                        number: attr[:number],
                        patent_expiration: attr[:patent_expiration],
                        drug_substance_claim: attr[:drug_substance_claim],
                        drug_product_claim: attr[:drug_product_claim],
                        patent_code_id: attr[:patent_code_id],
                        delist_requested: attr[:delist_requested]
                    })
      p "----Patent-----#{attr[:number]}--saved"
    rescue Exception => e
      Rails.logger.error "Scraper::PatentsUpdate ERRROR! Message: #{e}. Patent number: #{attr[:number]}."

    end
  end
end
