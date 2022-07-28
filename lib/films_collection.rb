require_relative "film"
require "nokogiri"
require "net/http"

class FilmsCollection
  KINOPOISK_URL = "https://www.kinopoisk.ru/lists/movies/top250/".freeze
  DATA_FROM_KINOPOISK = "#{File.expand_path("../..", __FILE__ )}/data/kinopoisk.html".freeze

  def self.parse_from_kinopoisk
    unless File.exist?(DATA_FROM_KINOPOISK)
      uri = URI.parse(KINOPOISK_URL)
      response = Net::HTTP.get_response(uri)
      File.write(DATA_FROM_KINOPOISK, response.body)
    end
    doc = Nokogiri::HTML(File.read(DATA_FROM_KINOPOISK))

    films_collection =
      doc.css(".base-movie-main-info_link__YwtP1").map do |tag|
        title = tag.css(".base-movie-main-info_mainInfo__ZL_u3").text

        director = tag.css(".desktop-list-main-info_additionalInfo__Hqzof")
                      .text
                      .gsub(/\X+Режиссёр: |В ролях:\X+/, "")

        film_info = tag.css(".desktop-list-main-info_secondaryText__M_aus").text
        release_year = film_info.gsub(/\D/, "").slice(0, 4)

        Film.new(title, director, release_year)
      end

    directors_list = films_collection.map(&:director).uniq.sort
    new(films_collection, directors_list)
  end

  def initialize(films_collection, directors_list)
    @films_collection = films_collection
    @directors_list = directors_list
  end

  def get_recommendation(answer)
    suitable_films = @films_collection.select { |film| film.director?(@directors_list[answer - 1]) }
    suitable_films.sample.output
  end

  def print_directors_list
    @directors_list.map.with_index(1) { |director, index| "#{index} - #{director}" }
  end
end
