class TemplatesController < ApplicationController


  def films
    render 'templates/films', layout:nil
  end

  def queue
    render 'templates/queue', layout:nil
  end

end
