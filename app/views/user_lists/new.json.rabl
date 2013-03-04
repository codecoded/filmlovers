object @films_list

attributes :description, :name


node(:url) {|films_list| user_lists_path( )}
node(:lists_url) {|films_list| user_lists_path( )}


if @films_list.films
  node(:films) do |films_list|
    partial "films/show", :object => films_list.films
  end
end