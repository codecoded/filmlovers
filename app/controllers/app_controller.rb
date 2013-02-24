class AppController < ApplicationController
  
  def index
    render_template
  end

  def preview
  end

  def login
    render partial: 'login' 
  end
end
