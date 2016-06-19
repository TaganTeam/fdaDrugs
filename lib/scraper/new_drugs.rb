module Scraper
  class NewDrugs < BaseDrugs

    def parse_new_drugs
      new_drugs_page = get_new_drugs_page('http://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm?fuseaction=Reports.ReportsMenu')
      new_drugs_page.search('table[summary="Original New Drug Application(NDA) Approvals"] tr[valign="top"]').each do |drug_row|
        if new_app? drug_row
          drug_details_page = get_new_drug_details_page(new_drugs_page)
          new_app_data = get_drug_details(drug_details_page)
          drug = save_or_find_drug(new_app_data)
          save_new_drug_app(new_app_data, drug.id)

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

    def get_new_drug_details_page page
      text = page.at('#user_provided table td.DataRow a').text
      link = page.link_with(text: text)
      new_drug_page = link.click
      new_drug_page
    end

    private

    def save_new_drug_app attr, drug_id
      DrugApplication.create(application_number: attr[:application_number], company: attr[:company], approval_date: attr[:approval_date], drug_id: drug_id)
    rescue Exception => e
      Rails.logger.error "Scraper::NewDrug ERRROR! Message: #{e}. Drug name: #{attr[:brand_name]}. App No: #{attr[:application_number]}."
    end





    # def parse_new_drugs
    #   mechanize = Mechanize.new
    #
    #   page = mechanize.get('http://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm?fuseaction=Reports.ReportsMenu')
    #   form = page.form('MonthlyApprovalsAll')
    #
    #   form.radiobutton_with(id: /OriginalNewDrugApprovals/).check
    #
    #   new_page = form.submit
    #
    #   new_page.search('table[summary="Original New Drug Application(NDA) Approvals"] tr[valign="top"]').each do |drug_row|
    #     attrs = drug_attrs(drug_row)
    #     new_drug = Drug.new(attrs)
    #     unless new_drug.save
    #       Rails.logger.error "Scraper::NewDrugs ERROR! Message: #{new_drug.errors.messages}. Drug attributes: #{attrs}."
    #     end
    #   end
    # end
    #
    # def drug_attrs drug_row
    #   {
    #     brand_name: (clear_name(drug_row.search('td.DataRow')[0].text).split('(')[0] rescue ''),
    #     generic_name: (drug_row.search('td.DataRow')[1].text rescue '')
    #   }
    # end
  end
end