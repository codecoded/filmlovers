object @films_page

attributes :description

node(:page_no){|films_page| films_page.results_page.page_no }
node(:total_results){|films_page| films_page.results_page.total_results }
node(:page_size){|films_page| films_page.results_page.page_size }
node(:total_pages){|films_page| films_page.results_page.total_pages }

node :films do |films_page|
  films_page.films.map do |film|
    partial "films/film_summary", :object => film
  end
end



