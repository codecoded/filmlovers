object false


extends 'api/v1/shared/header'

node :counters do 
  film.counters.to_json
end