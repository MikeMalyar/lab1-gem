require 'open-uri'
require 'byebug'
require 'nokogiri'
require 'csv'

class Parser

  def initialize
    @content=""
  end

  def get_content(url)
    html = URI.open(url) { |result| result.read }
    @content = Nokogiri::HTML(html).at('table#offers_table')
  end

  def get_data
    @titles = @content.css('.marginright5.link.linkWithHash.detailsLink > strong').map { |n| n.text }
    @prices = @content.css('.price').map { |n| n.text.gsub(/[ \n]/, '') }

    @locations = []
    @times = []
    @content.css('.breadcrumb.x-normal > span').each do |n|
      @icon = n.css('i')
      case @icon[0].attribute("data-icon").to_s
      when "location-filled"
        @locations.append(n.text)
      when "clock"
        @times.append(n.text)
      else
        puts n.text
      end
    end

    @links = @content.css('.marginright5.link.linkWithHash.detailsLink').map { |n| n.attribute("href") }
    @image_links = @content.css('.fleft').map { |n| n.attribute("src").to_s }

    # @days = @content.css('.widget__item > .w_date > a').map{ |n| n }
    # @weathers = @content.css('.widget__item > .widget__value > span').map{ |n| n.attribute('data-text').value }
    # @temperature = @content.css('.widget__row > .w_temperature > .chart__temperature > .values > .value').map { |n| n }
    # @winds = @content.css('.widget__item > .w_wind > .w_wind__warning > .unit_wind_m_s').map{ |n| n.text.gsub(/[ \n]/, '') }
    # @precipitations = @content.css('.widget__item > .w_prec > .w_prec__value').map{ |n| n.text.gsub(/[ \n]/, '') }
  end

  #byebug


  def write_to_file(filename)
    # CSV.open(filename, 'w+') do |file|
    #   file << ['day_of_week', 'day_of_month', 'weather', 'min_temperature', 'max_temperature', 'wind', 'precipitation']
    #   (0..9).each do |i|
    #     file << [
    #       @days[i].css('div').text,
    #       @days[i].css('span').text.gsub(/[ \n]/, ''),
    #       @weathers[i],
    #       @temperature[i].css('.mint > .unit_temperature_c').text,
    #       @temperature[i].css('.maxt > .unit_temperature_c').text,
    #       @winds[i],
    #       @precipitations[i]
    #     ]
    #   end
    # end

  end

  url = 'https://www.olx.ua/hobbi-otdyh-i-sport/chernovtsy/'
  parser = Parser.new
  parser.get_content(url)
  parser.get_data
  parser.write_to_file("output.csv")
end


#byebug
