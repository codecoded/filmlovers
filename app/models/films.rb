class Films
  FilmLists = [:watched, :loved, :unloved]

  def self.[](list)
    @lists ||= {}
    FilmLists.each do |list|
      @lists[list] =  FilmsScoreChart.new("films:#{list}")
    end
    @lists[list]
  end

end