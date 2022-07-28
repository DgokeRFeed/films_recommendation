require_relative "lib/films_collection"

films = FilmsCollection.parse_from_kinopoisk

puts "Топ 50 Кинопоиска"
puts "Фильм какого режиссера ты бы хотел посмотреть?"
puts "(введи номер режиссера из списка)"
puts films.print_directors_list
answer = gets.to_i

puts
puts "Рекомендую посмотреть"
puts films.get_recommendation(answer)
