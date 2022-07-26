require_relative "lib/films_collection"

FilmsCollection.parse_films

# all_films =
#   path_data.map do |path|
#     lines = File.readlines(path, chomp:true)
#     Film.new(lines[0], lines[1], lines[2])
#   end
#
# all_directors = all_films.map(&:director).uniq
#
# puts
# puts "Фильм какого режиссера ты хотел бы посмотреть?"
# puts "(введи номер режиссера из списка)"
#
# all_directors.each.with_index(1) do |option, index|
#   puts "#{index}: #{option}"
# end
#
# answer = gets.to_i
# films_pool =
#   all_films.select { |film| film.director?(all_directors[answer - 1]) }
#
# recommendation = films_pool.sample
# puts
# puts "Рекомендую посмотреть:"
# puts recommendation.output
