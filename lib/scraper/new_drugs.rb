module Scraper
  class NewDrugs < BaseDrugs

    attr_accessor :app, :no_results

    def parse_new_drugs
      new_apps = []
      new_drugs_page = get_new_drugs_page('http://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm?fuseaction=Reports.ReportsMenu')
      new_drugs_page.search('table[summary="Original New Drug Application(NDA) Approvals"] tr[valign="top"]').each_with_index do |drug_row, index|
        if new_app? drug_row
          drug_details_page = get_new_drug_details_page(new_drugs_page, index)

          if @no_results.blank?
            new_drug_table = get_target_table(drug_details_page, DRUG_DETAIL_TABLE_INDEX)
            new_products_table = get_target_table(drug_details_page, DRUG_PRODUCTS_TABLE_INDEX)

            new_app_data = get_drug_details(new_drug_table)
            drug = save_or_find_drug(new_app_data)

            save_new_drug_app(new_app_data, drug.id)
            new_apps << @app
            new_product_data = get_products_details(new_products_table, @app.application_number, true)
            products = save_products(@app, new_product_data)
            products.each do |product|
              save_patent_exclusivity_for(@app.application_number, product) if product.patent_status
            end
          else
            p "---new_apps----#{new_apps}"
            send_no_drugs
           return @no_results
          end
        end
      end
      unless new_apps.empty?
        p "---new_apps----#{new_apps}"
        send_emails(new_apps)
      else
        p "---new_apps----#{new_apps}"
        send_no_drugs
      end


    end

    def get_new_drugs_page url
      page = get_data_page(url)
      form = page.form('MonthlyApprovalsAll')
      form.radiobutton_with(id: /OriginalNewDrugApprovals/).check
      new_page = form.submit

      empty_table = get_target_table(new_page, 2)

      text = empty_table.search('td strong a').text
      link = new_page.link_with(text: text)
      previous_page = link.click

      previous_page


      # new_page
    end

    def send_emails(new_apps)
      User.find_each do |user|
        DrugsMailer.delay.new_drugs(new_apps, user)
      end
    end

    def send_no_drugs
      User.find_each do |user|
        DrugsMailer.delay.no_drugs(user)
      end
    end

    def new_app? row
      app_number = row.search('td.DataRow')[0].text.gsub(/[^\d]/, '')
      DrugApplication.find_by_application_number(app_number).nil? ? true : false
    end

    def get_new_drug_details_page(page, i)
      links = page.search('#user_provided table td.DataRow a')
      unless links.blank?
        text = links[i].text
        link = page.link_with(text: text)
        new_drug_page = link.click
        new_drug_page
      else
        @no_results = clear_symbols page.search('#user_provided table td.DataRow').text
      end
    end

    private

    def save_new_drug_app attr, drug_id
      @app = DrugApplication.create(application_number: attr[:application_number], company: attr[:company], approval_date: attr[:approval_date], drug_id: drug_id)
      p "#{@app.application_number}--saved"
    rescue Exception => e
      Rails.logger.error "Scraper::NewDrug ERRROR! Message: #{e}. Drug name: #{attr[:brand_name]}. App No: #{attr[:application_number]}."
    end
  end
end
