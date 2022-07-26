require_relative "film"
require "nokogiri"
require "open-uri"

class FilmsCollection
  URL = "https://www.kinonews.ru/top100/".freeze
  FILE = "#{File.dirname(__FILE__ )}/data.html}".freeze

  def self.parse_films
    doc = Nokogiri::HTML(URI.open(URL))
    # doc.to_html(FILE)

    titles_array = doc.css(".titlefilm").map(&:text)

    directors_array = doc.css(".rating_rightdesc div[4] a").map(&:text)

    release_year = doc.css("div[class=bigtext]").map do |string|
      year = string.text
      year.slice(year.length - 4, 4)
    end

    puts titles_array
    puts directors_array
    puts release_year
  end

  def initialize(films_collection)
    @films_collection = films_collection
  end
end
