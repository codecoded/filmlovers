object @films_list

attributes :description, :name


node(:url) {|films_list| user_lists_path( )}
node(:lists_url) {|films_list| user_lists_path( )}


if @films_list.films
node(:film_list_items) do |films_list|
  partial("user_lists/film_list_item", :object => films_list.film_list_items) 
end

  
end