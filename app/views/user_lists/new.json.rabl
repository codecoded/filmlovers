object @films_page

attributes :description, :name


node(:url) {|films_page| user_lists_path( )}
node(:lists_url) {|films_page| user_lists_path( )}

if @films_page.films
  node(:films) do |films_page|
    partial "films/show", :object => films_page.films
  end
end