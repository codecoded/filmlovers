class ResultsPage
  
  attr_reader :results, :total_results, :page_size, :page_no

  def initialize(results, total_results=0, page_size=20, page=1)
    @results, @total_results, @page_size, @page_no = results, total_results, page_size, page
  end

 def self.from_tmdb(films, tmdb_result)
    new films.map(&:id), tmdb_result['total_results'], 20, tmdb_result['page']
  end

  def total_pages
    (total_results / page_size.to_f).ceil
  end

  def more_pages?
    page_no < total_pages
  end

end