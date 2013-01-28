module SearchHelper


  def page_search_results(page_no, page_total)
    
    content = ''
    page_total.times.each do |index|

      page_index = index+1

      current_class = page_index == page_no ? 'current' : nil

      content += content_tag :li, nil, :class => current_class do
        link_to page_index, params.merge({page:page_index})
        # search_films_path(query: params[:query], page: page_index) 
      end

    end
    content.html_safe
  end

end
