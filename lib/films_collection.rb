require_relative "film"
require "nokogiri"
require "net/http"

class FilmsCollection
  URL = "https://www.kinonews.ru/top100/".freeze
  FILE = "#{File.expand_path("../..", __FILE__ )}/data/data.html".freeze

  def self.parse_films
    uri = URI.parse(URL)
    response = Net::HTTP.get_response(uri)
    File.write(FILE, response.body)
    doc = Nokogiri::HTML(File.read(FILE))
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
