object @films_page

attributes :description

if @films_page.previous?
  node(:url_previous){|films_page| current_url(films_page.previous_params)}
end

if @films_page.next?
  node(:url_next){|films_page| current_url films_page.next_params}
end

node(:url){|films_page| current_url format:'html'}

node(:page_no){|films_page| films_page.results_page.page_no }
node(:total_results){|films_page| films_page.results_page.total_results }
node(:page_size){|films_page| films_page.results_page.page_size }
node(:total_pages){|films_page| films_page.results_page.total_pages }

node :films do |films_page|

  films_page.films.map do |film|
    partial "films/show", :object => film
  end
end



