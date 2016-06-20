module Scraper
  class AllAppNumbers < BaseDrugs

    def initialize; end


    def parse_all_app_numbers
      File.open('lib/scraper/data_files/application.txt').each_with_index do |line, index|
        create_appNum(line[0..6]) unless index == 0
      end
    end



    private

    def create_appNum number
      DrugApplication.create(application_number: number.gsub(/\t/,'') )
    rescue Exception => e
      Rails.logger.error "Scraper::Drugs ERRROR! Message: #{e}. App Number: #{number}."
    end
  end
end