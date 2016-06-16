module Scraper
  require 'wombat'
  require 'mechanize'

  class BaseDrugs

    private

    def clear_name name
      name.gsub(/\r|\n|\t/,'').gsub(/\s+/, ' ')
    end

  end
end