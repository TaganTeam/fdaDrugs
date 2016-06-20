module Scraper
  class NewDrugs < BaseDrugs

    attr_accessor :app

    def parse_new_drugs
      new_drugs_page = get_new_drugs_page('http://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm?fuseaction=Reports.ReportsMenu')
      new_drugs_page.search('table[summary="Original New Drug Application(NDA) Approvals"] tr[valign="top"]').each_with_index do |drug_row, index|
        if new_app? drug_row
          drug_details_page = get_new_drug_details_page(new_drugs_page, index)

          new_drug_table = get_drug_table(drug_details_page)
          new_products_table = get_products_table(drug_details_page)

          new_app_data = get_drug_details(new_drug_table)
          drug = save_or_find_drug(new_app_data)

          save_new_drug_app(new_app_data, drug.id)
          save_products(@app, get_products_details(new_products_table, @app.application_number, true))
        end
      end
    end

    def get_new_drugs_page url
      page = get_data_page(url)
      form = page.form('MonthlyApprovalsAll')
      form.radiobutton_with(id: /OriginalNewDrugApprovals/).check
      new_page = form.submit
      new_page
    end

    def new_app? row
      app_number = row.search('td.DataRow')[0].text.gsub(/[^\d]/, '')
      DrugApplication.find_by_application_number(app_number).nil? ? true : false
    end

    def get_new_drug_details_page(page, i)
      text = page.search('#user_provided table td.DataRow a')[i].text
      link = page.link_with(text: text)
      new_drug_page = link.click
      new_drug_page
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