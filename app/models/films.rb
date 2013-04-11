class Films
  FilmLists = [:watched, :loved, :unloved, :owned]

  def self.[](action)
    FilmUserAction[action]
  end

  def self.count_for(action)
    [action].count
  end

end