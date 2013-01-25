class SearchResultPresenter

  attr_reader :user, :search

  def initialize(user, search)
    @user, @search = user, search
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