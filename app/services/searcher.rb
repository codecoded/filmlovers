class Searcher
  
  attr_reader :query, :page_no, :page_size

  def initialize(query, page_no=1, page_size=28)
    @query, @page_no, @page_size = query, page_no, page_size
  end

  def postcode?
    !!(query =~ /^\s*((GIR\s*0AA)|((([A-PR-UWYZ][0-9]{1,2})|(([A-PR-UWYZ][A-HK-Y][0-9]{1,2})|(([A-PR-UWYZ][0-9][A-HJKSTUW])|([A-PR-UWYZ][A-HK-Y][0-9][ABEHMNPRVWXY]))))\s*[0-9][ABD-HJLNP-UW-Z]{2}))\s*$/i)
  end

  def cinemas
    @cinema ||= Cinema.near(query) if postcode? 
  end

  def films
    @films ||= Film.search(query, :title, :release_date, :desc).page(page_no).per(page_size)
  end

  def count
    @count ||= postcode? ? cinemas.count : films.count 
  end
end