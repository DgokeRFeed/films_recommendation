class Film
  attr_reader :title, :director, :release_year

  def initialize(title, director, release_year)
    @title = title
    @director = director
    @release_year = release_year
  end

  def director?(director)
    @director == director.capitalize
  end

  def output
    "#{@title} (#{@release_year})"
  end
end

