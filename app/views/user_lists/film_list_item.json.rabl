collection @film_list_items

node(:position) {|film_list_item| 1}
node(:film) {|film_list_item| partial("films/_film_summary", :object =>  film_list_item)}

