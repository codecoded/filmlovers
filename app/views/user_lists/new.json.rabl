object @films_page

attributes :description, :name


node(:url) {|films_page| user_lists_path( )}
node(:lists_url) {|films_page| user_lists_path( )}

if @films_page.films_from_queue
  node(:films) do |films_page|
    films_page.films_from_queue.map do |film|
      partial "films/show", :object => film
    end
  end
end