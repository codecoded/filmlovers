class AppController < ApplicationController
  
  def index
    render layout:nil if request.xhr?
  end

  def preview
  end

  def login
    render partial:'login', layout:nil
  end
end
