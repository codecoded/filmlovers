class SearchResultPresenter

  attr_reader :user, :search, :type

  def initialize(user, search, type)
    @user, @search, @type = user, search, type
  end

  def count
    @search.total_results
  end

  def page_no
    @search.page
  end

  def page_total
    @search.total_pages
  end
end