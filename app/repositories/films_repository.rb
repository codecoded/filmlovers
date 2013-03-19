class FilmsRepository

  def self.top_for(list_name, count=10)
    Film.find Films[list_name].films(count-1)
  end
end