class AppController < ApplicationController
  
  def index
  end

  def preview
  end

  def login
    render partial:"scripts/modal", locals:{html_partial: 'login'}, layout:nil
  end
end
