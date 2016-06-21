require 'roo'

module Scraper
  class ExclusivityCodes < BaseDrugs

    def parse_exclusivity_codes
      xls = Roo::Spreadsheet.open('./lib/scraper/data_files/exclysivityCodes.xlsx', extension: :xlsx)

      xls.each_row_streaming(offset: 1) do |row|
        create_code(clear_name(row[0].cell_value), row[1].cell_value)
      end
    end




    private

    def create_code code, definition
      ExclusivityCode.create(code: code, definition: definition)
      p "-code-#{code}---saved"

    rescue Exception => e
      Rails.logger.error "Scraper::ExclusivityCodes ERRROR! Message: #{e}. Exclusivity Code: #{code}."
    end
  end
end