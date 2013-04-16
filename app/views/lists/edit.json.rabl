object @films_list

attributes :description, :name, :id

node(:url) {|films_list| user_list_path( films_list.user, films_list)}
node(:edit_url) {|films_list| edit_user_list_path( films_list.user, films_list)}
node(:lists_url) {|films_list| user_lists_path( )}

node(:film_list_items) do |films_list|
  partial("user_lists/film_list_item", :object => films_list.film_list_items) 
end