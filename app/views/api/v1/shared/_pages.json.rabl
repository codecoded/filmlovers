extends 'api/v1/shared/header'
node :pages do
  {
    :previous       => @query.page > 1 ? url_for(params.merge({page: @query.page-1}))  : nil,
    :next           => @query.total_pages > @query.page ?  url_for(params.merge({page: @query.page+1})) : nil,
    :page_no        => @query.page,
    :total_results  => @query.results_count,
    :page_size      => @query.page_size,
    :total_pages    => @query.total_pages,
    :order          => @query.sort_order,
    :by             => @query.sort_by,
  }
end