module Scraper
  class Patents < BaseDrugs

    def parse_patents
      DrugApplication.all.each do |app|
        app.app_products.each do |product|
          patents_page = get_data_page("http://www.accessdata.fda.gov/scripts/cder/ob/docs/patexclnew.cfm?Appl_No=#{app}&Product_No=#{product}&table1=OB_Rx")
          patents_table = get_patents_table(patents_page)

          patent_data = get_patents_data(patents_table)



        end
      end

    end


    def get_patents_data table
      search_results = {}

      table.search('tr').each_with_index do |row, i|
        unless i == 0
          search_results[:patent_no] = row.search('td')[2].text
        end
      end
    end



  end
end