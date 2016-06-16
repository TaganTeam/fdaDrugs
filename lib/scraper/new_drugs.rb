module Scraper
  class NewDrugs < BaseDrugs
    def parse_new_drugs
      mechanize = Mechanize.new

      page = mechanize.get('http://www.accessdata.fda.gov/scripts/cder/drugsatfda/index.cfm?fuseaction=Reports.ReportsMenu')
      form = page.form('MonthlyApprovalsAll')

      form.radiobutton_with(id: /OriginalNewDrugApprovals/).check

      new_page = form.submit

      new_page.search('table[summary="Original New Drug Application(NDA) Approvals"] tr[valign="top"]').each do |drug_row|
        attrs = drug_attrs(drug_row)
        new_drug = Drug.new(attrs)
        unless new_drug.save
          Rails.logger.error "Scraper::NewDrugs ERROR! Message: #{new_drug.errors.messages}. Drug attributes: #{attrs}."
        end
      end
    end

    def drug_attrs drug_row
      {
        brand_name: (clear_name(drug_row.search('td.DataRow')[0].text).split('(')[0] rescue ''),
        generic_name: (drug_row.search('td.DataRow')[1].text rescue '')
      }
    end
  end
end