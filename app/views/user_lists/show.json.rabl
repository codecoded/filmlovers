object @films_page

attributes :description, :name, :id

node(:url) {|films_page| user_list_path( films_page.user, films_page.films_list)}
node(:lists_url) {|films_page| user_lists_path( )}


node(:films) do |films_page|
  partial "films/show", :object => films_page.films
end