require 'open-uri'
require 'nokogiri'
require 'csv'

class OlxParser

  def initialize
    @ordinary_content=""
    @top_content=""
  end

  def parse_to_csv(url)
    get_html_content(url)
    parse_data(@ordinary_content)
    write_data_to_file("ordinary_offers.csv")
    parse_data(@top_content)
    write_data_to_file("top_offers.csv")
  end

  def get_html_content(url)
    html = URI.open(url) { |result| result.read }
    @ordinary_content = Nokogiri::HTML(html).at('table#offers_table')
    @top_content = Nokogiri::HTML(html).at('table.offers--top')
  end

  def parse_data(content)
    @titles = content.css('.marginright5.link.linkWithHash.detailsLink > strong').map { |n| n.text.gsub(/[\n]/, ' ') }
    @prices = content.css('.price').map { |n| n.text.gsub(/[ \n]/, '') }

    @locations = []
    @times = []
    content.css('.breadcrumb.x-normal > span').each do |n|
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

    @links = content.css('.marginright5.link.linkWithHash.detailsLink').map { |n| n.attribute("href") }
    @image_links = content.css('.fleft').map { |n| n.attribute("src").to_s }
  end

  def write_data_to_file(filename)
    CSV.open(filename, 'w+') do |file|
      file << %w[title price location date_time_added link image_link]
      (0..@titles.length - 1).each do |i|
        file << [
          @titles[i], @prices[i], @locations[i], @times[i], @links[i], @image_links[i]
        ]
      end
    end
  end

  url = 'https://www.olx.ua/hobbi-otdyh-i-sport/chernovtsy/'
  parser = OlxParser.new
  parser.parse_to_csv(url)
end
