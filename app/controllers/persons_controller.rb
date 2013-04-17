class PersonsController < ApplicationController

  def index
    render_template
  end
  
  def show
    @person_view = PersonPresenter.new current_user, Person.fetch(params[:id])
    render_template
  end

  helper_method :person

  protected

  def person
    @person ||= Person.fetch(params[:id])
  end
end