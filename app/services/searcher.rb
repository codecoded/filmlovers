class Searcher
  
  attr_reader :query

  def initialize(query)
    @query = query
  end


  def postcode?
    !!(query =~ /^\s*((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))\s*$/i)
  end

  def cinemas
    @cinema ||= Cinema.near(query) if postcode? 
  end

  def films
    @films ||= Films.search(query, :title)
  end

  def count
    @count ||= postcode? ? cinemas.count : films.count 
  end

  def search
    @search ||= postcode? ? cinemas : films
  end
end