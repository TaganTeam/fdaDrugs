require 'wombat'
require 'mechanize'

module Scraper
  class BaseDrugs

    private

    def clear_name name
      name.gsub(/\r|\n|\t/,'').gsub(/\s+/, ' ')
    end

  end
end