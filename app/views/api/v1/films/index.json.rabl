object false

cache url_for(params), expires_in: 12.hours
node :header do
  {
    version:    'v1',
    domain:     "#{request.protocol}#{request.host}:#{request.port}",
    timestamp:  Time.now.utc,
    url:        url_for(params)
  }
end 

node :pages do
  {
    :previous       => page_no > 1 ? url_for(params.merge({page: page_no-1}))  : nil,
    :next           => @total_pages > page_no ?  url_for(params.merge({page: page_no+1})) : nil,
    :page_no        => page_no,
    :total_results  => @films_count,
    :page_size      => page_size,
    :total_pages    => @total_pages,
    :order          => order,
    :by             => by,
  }
end




node :films do 
  @films.map do |film|
    partial "api/v1/films/show", :object => film, :locals => { :hide_header => true }
  end
end


