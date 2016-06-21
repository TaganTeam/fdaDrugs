module Scraper
  class PatentUseCodes < BaseDrugs

    def parse_patent_codes
      xls = Roo::Spreadsheet.open('./lib/scraper/data_files/patentCodes.xlsx', extension: :xlsx)

      xls.each_row_streaming(offset: 1) do |row|
        create_code(clear_name(row[0].cell_value), row[1].cell_value)
      end
    end


    private

    def create_code code, definition
      PatentCode.create(code: code, definition: definition)
      p "-code-#{code}---saved"

    rescue Exception => e
      Rails.logger.error "Scraper::PatentUseCodes ERRROR! Message: #{e}. Patent Use Code Code: #{code}."
    end
  end
end