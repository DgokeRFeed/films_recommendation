class Film
  attr_reader :title, :director, :release_year

  def initialize(title, director, release_year)
    @title = title
    @director = director
    @release_year = release_year
  end

  def director?(director)
    @director == director
  end

  def output
    "#{@title} - #{@director} (#{@release_year})"
  end
end

