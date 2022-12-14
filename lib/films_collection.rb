require_relative "film"
require "nokogiri"
require "net/http"

# Класс, ответственный за парсинг фильмов и выдачу рекомендаций, какой из них посмотреть
class FilmsCollection
  KINOPOISK_URL = "https://www.kinopoisk.ru/lists/movies/top250/".freeze
  DATA_FROM_KINOPOISK = "#{File.expand_path("../..", __FILE__ )}/data/kinopoisk.html".freeze

  # Метод парсит фильмы с сайта "Кинопоиск" и создает коллекцию объектов "Фильм".
  # Данные парсинга каждый раз сохраняются в файле "data/kinopoisk.html", поэтому,
  # если по какой-либо причине спарсить не удалось, данные беруться из него.
  def self.parse_from_kinopoisk
    uri = URI.parse(KINOPOISK_URL)
    response = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML(response.body)
    check_tag = doc.css(".base-movie-main-info_link__YwtP1")

    if check_tag.empty?
      doc = Nokogiri::HTML(File.read(DATA_FROM_KINOPOISK))
    else
      File.write(DATA_FROM_KINOPOISK, response.body)
    end

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
    new(films_collection)
  end

  def initialize(films_collection)
    @films_collection = films_collection
  end

  # Метод получает на вход одного из предложенных режиссеров и выбирает случайно один
  # из его фильмов из коллекциии
  def get_recommendation(director_index)
    @films_collection.select { |film| film.director?(@directors_list[director_index - 1]) }.sample
  end

  # Метод создает список режиссеров на основе списка полученных фильмов
  def print_directors_list
    @directors_list = @films_collection.map(&:director).uniq.sort
    @directors_list.map.with_index(1) { |director, index| "#{index} - #{director}" }
  end
end
