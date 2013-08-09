class PersonsController < ApplicationController

  def index
  end
  
  def show
  end

  

  protected

  def person
    @person ||= Person.fetch(params[:id])
  end

  helper_method :person
end