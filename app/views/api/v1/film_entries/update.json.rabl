object false


extends 'api/v1/shared/header'

node :film_action do
  {
    params[:id] => film_entry.set?(params[:id])
  }
end