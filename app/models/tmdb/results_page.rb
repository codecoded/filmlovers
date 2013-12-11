class Tmdb::ResultsPage

  attr_reader :data
  def initialize(data)
    @data = data
  end

  def results
    data['results']
  end

  def page_no
    data['page']
  end

  def total_results
    data['total_results']
  end

  def total_pages
    data['total_pages']
  end

  def more_pages?
    page_no < total_pages
  end
end