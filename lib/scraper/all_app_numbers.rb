module Scraper
  class AllAppNumbers < BaseDrugs
    # STEP_SIZE=100
    #
    # attr_accessor :drug_fullnames, :current_category, :start_row

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

    # def parse
    #   [*('A'..'Z'), '0-9'].each do |category|
    #     @current_category = category
    #     parse_category
    #   end
    # end
    #
    # def parse_category
    #   set_current_start_row
    #   sleep 0.5
    #   get_drug_names
    #   ensure_drugs!
    #
    #   if @drug_fullnames.kind_of?(Array) && @drug_fullnames.blank?
    #     @start_row = nil
    #   else
    #     parse_category
    #   end
    # end
    #
    # def get_drug_names
    #   current_category, start_row = @current_category, @start_row
    #   result = Wombat.crawl do
    #     base_url 'https://www.accessdata.fda.gov'
    #     path "/scripts/cder/drugsatfda/index.cfm?fuseaction=Search.SearchResults_Browse&StartRow=#{start_row}&StepSize=#{STEP_SIZE}&DrugInitial=#{current_category}"
    #     drug_fullnames({css: '.product_table li'}, :list)
    #   end
    #
    #   @drug_fullnames = result['drug_fullnames']
    # end
    #
    # def ensure_drugs!
    #   @drug_fullnames.each { |name| create_drug name }
    # end

    # private

    # def create_drug name
    #   raise 'Drug name has more than one brack' if check_more_than_one_bracks(name)
    #   full_name_arr = clear_name(name).split(' (')
    #   Drug.create(brand_name: full_name_arr[0], generic_name: full_name_arr[1].gsub(/\)$/, ''))
    # rescue Exception => e
    #   Rails.logger.error "Scraper::Drugs ERRROR! Message: #{e}. Drug name: #{name}."
    # end
    #
    # def check_more_than_one_bracks name
    #   name.scan(/\(.*?\)/).size > 1
    # end
    #
    # def set_current_start_row
    #   if @start_row.blank?
    #     @start_row = 1
    #   else
    #     @start_row += 100
    #   end
    # end
  end
end